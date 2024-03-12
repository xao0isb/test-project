# frozen_string_literal: true

class DownloadController < ApplicationController
  def file
    path = permitted_params[:file_path]

    send_file path

    post = Post.find(permitted_params[:post_id])
    redirect_to post, notice: "Файл скоро начнет установку!"
  end

  def permitted_params
    params.permit(:post_id, :file_path)
  end
end
