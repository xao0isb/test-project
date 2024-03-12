# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit::Authorization

  UNAUTHORIZED_METHODS = %w[POST DELETE PATCH].freeze

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def authenticate_user!
    if current_user.nil?
      return head :unauthorized if UNAUTHORIZED_METHODS.include?(request.method)

      redirect_to new_user_session_path
    end

    true
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: User::PERMITTED_PARAMETERS)
  end

  def user_not_authorized
    head :forbidden
  end
end
