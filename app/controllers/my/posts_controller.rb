# frozen_string_literal: true

module My
  class PostsController < ApplicationController
    def show
      @posts = current_user.posts.not_drafts
    end
  end
end
