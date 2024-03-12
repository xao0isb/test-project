# frozen_string_literal: true

module My
  class DraftsController < ApplicationController
    def show
      @posts = current_user.posts.drafts
    end
  end
end
