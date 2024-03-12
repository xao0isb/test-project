# frozen_string_literal: true

class User < ApplicationRecord
  PERMITTED_PARAMETERS = %i[first_name last_name middle_name region_id].freeze

  devise :registerable,
         :database_authenticatable,
         :rememberable,
         authentication_keys: %i[login]

  belongs_to :region
  has_many :posts, inverse_of: :creator, dependent: :restrict_with_exception

  validates :login, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :middle_name, presence: true
  validates :password, presence: true
  validates :password, confirmation: true

  scope :not_admins, -> { where("role != 'admin'") }

  def full_name
    "#{last_name} #{first_name} #{middle_name}"
  end

  def admin?
    role == "admin"
  end

  def switch_to_admin
    update_attribute(:role, "admin") # rubocop:disable Rails/SkipsModelValidations
  end
end
