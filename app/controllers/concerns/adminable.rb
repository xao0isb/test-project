# frozen_string_literal: true

require "active_support/concern"

module Adminable
  extend ActiveSupport::Concern

  private

  def authorize_admin!
    authorize current_user, :admin?
  end
end
