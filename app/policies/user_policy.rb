# frozen_string_literal: true

class UserPolicy
  attr_reader :current_user, :record

  def initialize(current_user, record)
    @current_user = current_user
    @record = record
  end

  def current_user?
    @current_user.id == @record.id
  end

  def admin?
    @current_user.admin?
  end

  def not_admin?
    !admin?
  end
end
