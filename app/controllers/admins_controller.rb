# frozen_string_literal: true

class AdminsController < ApplicationController
  include Adminable

  before_action :authorize_admin!

  # TODO: dont think that this is best practice
  skip_before_action :verify_authenticity_token, only: :create

  def new
    @select_options = User.not_admins.map { |u| [u.full_name, u.id] }
  end

  def create
    @new_admin = User.find(params[:id])

    if @new_admin.switch_to_admin
      # TODO: doesnt work with custom request from view
      redirect_to new_admin_path, notice: "Новый администратор был успешно добавлен!"
      flash[:notice] +=
        " Delayed Job пока не выполнил изменение состояния :) Перезагрузите страницу (; (это нужно будет поправить)"
    else
      render :new, status: :unprocessable_entity
    end
  end
end
