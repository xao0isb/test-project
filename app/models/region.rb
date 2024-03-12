# frozen_string_literal: true

class Region < ApplicationRecord
  has_many :users, dependent: :restrict_with_exception
  has_many :posts, dependent: :restrict_with_exception

  validates :name, presence: true
end
