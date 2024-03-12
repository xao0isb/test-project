# frozen_string_literal: true

class PostPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def submit?
    draft?
  end

  def destroy?
    draft?
  end

  private

  def draft?
    @record.status == "draft"
  end
end
