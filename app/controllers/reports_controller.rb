# frozen_string_literal: true

class ReportsController < ApplicationController
  include Adminable

  before_action :authorize_admin!

  def excel
    post_ids = permitted_params[:post_ids].map(&:to_i)
    posts = post_ids.map { |id| Post.find(id) }

    generate_file(data: posts)

    redirect_to root_url, notice: "Ваш отчет генерируется. Скоро он загрузится на ваше устройство."
  end

  private

  def permitted_params
    params.permit(post_ids: [])
  end

  def generate_file(data:)
    workbook = FastExcel.open
    worksheet = workbook.add_worksheet

    worksheet.append_row(Post::REPORT_PARAMS_TRANSLATED, workbook.bold_format)

    fill_with_data(worksheet, data)

    path = "#{Rails.root}#{workbook.filename}"
    send_file path, filename: "report.xlsx"

    workbook.close
  end

  def fill_with_data(worksheet, posts)
    posts.each do |post|
      worksheet << plain_values(post)
    end
  end

  def plain_values(post)
    values = []

    Post::REPORT_PARAMS.each do |param|
      value = post.send(param)

      if param == :creator
        value = value.full_name
      elsif param == :region
        value = value.name
      end

      value = value.to_fs(:db) if param == :created_at

      values << value
    end

    values
  end
end
