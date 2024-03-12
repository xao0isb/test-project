# frozen_string_literal: true

require "active_support/concern"

module Postable
  extend ActiveSupport::Concern

  private

  def post_params
    params.required(:post).permit(:user_id, :title, :content, :region_id, { images: [] }, { files: [] })
  end

  def authorize_creator!(creator = nil)
    if creator.nil?
      creator_id = post_params[:user_id].to_i
      creator = User.find(creator_id)
    end

    authorize creator, :current_user?
  end

  def authorize_region!
    unless current_user.admin?
      region_id = post_params[:region_id].to_i
      region = Region.find(region_id)
      authorize region, :current_user_region?
    end

    true
  end
end
