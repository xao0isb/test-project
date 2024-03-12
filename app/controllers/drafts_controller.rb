# frozen_string_literal: true

class DraftsController < ApplicationController
  include Postable

  before_action :authorize_creator!, :authorize_region!, only: :create

  # TODO: - rewrite
  skip_before_action :verify_authenticity_token, only: %i[create submit]

  def create
    post = current_user.posts.build(post_params)

    if post.save
      redirect_to post, notice: "Черновик сохранен!"
    else
      redirect_to new_post_path, status: :unprocessable_entity
    end
  end

  def submit
    draft = Post.find(params[:id])

    authorize_draft! draft

    Delayed::Job.enqueue Posts::SubmitJob.new(draft)
    Delayed::Job.enqueue Posts::ApproveJob.new(draft) if current_user.admin?

    alert_message = "Черновик был успешно опубликован! "
    alert_message += current_user.admin? ? "Скоро он появится в списке подтвержденных!" : "Скоро мы отправим его на проверку!"

    redirect_to draft, notice: alert_message
    flash[:notice] +=
      " Delayed Job пока не выполнил изменение состояния :) Перезагрузите страницу (; (это нужно будет поправить)"
  end

  def destroy
    draft = Post.find(params[:id])

    authorize_draft! draft

    if draft.delete
      redirect_to my_drafts_path, notice: "Черновик был успешно удален!"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def authorize_draft!(draft)
    creator = draft.creator

    authorize_creator! creator
    authorize draft
  end
end
