# frozen_string_literal: true

class RegionPolicy
  attr_reader :current_user, :record

  def initialize(current_user, record)
    @current_user = current_user
    @record = record
  end

  def current_user_region?
    return true if admin?

    @current_user.region.id == @record.id
  end

  private

  def admin?
    @current_user.admin?
  end
end
