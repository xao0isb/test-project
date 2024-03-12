# frozen_string_literal: true

class PostsController < ApplicationController
  include Postable

  before_action(
    :authorize_creator!,
    :authorize_region!,
    only: %i[create update destroy]
  )
  before_action :authorize_admin!, only: %i[approve decline]

  def index
    @posts = if current_user.admin?
               Post.reviews
             else
               region = current_user.region

               @region_name = region.name
               region.posts.not_drafts
             end
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create # rubocop:disable Metrics/AbcSize
    # TODO - rewrite
    return redirect_post(drafts_url, params: ::Operations::Params::DeepPermit.call(params)) if draft?

    @post = current_user.posts.build(post_params)

    if @post.save
      Delayed::Job.enqueue Posts::SubmitJob.new(@post)

      Delayed::Job.enqueue Posts::ApproveJob.new(@post) if current_user.admin?

      alert_message = "Пост был успешно создан! "
      alert_message += current_user.admin? ? "Скоро он появится в списке подтвержденных!" : "Скоро мы отправим его на проверку!"

      redirect_to @post, notice: alert_message
      flash[:notice] +=
        " Delayed Job пока не выполнил изменение состояния :) Перезагрузите страницу (; (это нужно будет поправить)"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post = Post.find(params[:id])

    # TODO: - rewrite
    return redirect_post(submit_draft_url(@post)) if submit?

    if @post.update(post_params)
      redirect_to @post, notice: "Черновик был успешно обновлен!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def approve
    post = Post.find(params[:id])

    Delayed::Job.enqueue Posts::ApproveJob.new(post)

    redirect_to post, notice: "Мы увидели ваш запрос. Пост скоро переместится в список подтвержденных!"
    flash[:notice] +=
      " Delayed Job пока не выполнил изменение состояния :) Перезагрузите страницу (; (это нужно будет поправить)"
  end

  def decline
    post = Post.find(params[:id])

    Delayed::Job.enqueue Posts::DeclineJob.new(post)

    redirect_to post, notice: "Мы увидели ваш запрос. Пост скоро переместится в список отклоненных!"
    flash[:notice] +=
      " Delayed Job пока не выполнил изменение состояния :) Перезагрузите страницу (; (это нужно будет поправить)"
  end

  private

  def authorize_admin!
    authorize current_user, :admin?
  end

  def submit?
    params.key?(:commit)
  end

  def draft?
    params.key?(:draft)
  end

  def change_status_params
    params.required(:post).permit(:status)
  end
end
