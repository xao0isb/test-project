# frozen_string_literal: true

class Post < ApplicationRecord
  include AASM

  VALIDATE_PARAMS = %i[title content].freeze
  REPORT_PARAMS = %i[region title content creator created_at].freeze
  REPORT_PARAMS_TRANSLATED = ["Регион", "Заголовок", "Содержание", "Автор", "Дата отправки на рассмотрение"].freeze

  belongs_to :creator, class_name: "User", foreign_key: "user_id", inverse_of: :posts
  belongs_to :region

  mount_uploaders :images, ImageUploader
  mount_uploaders :files, FileUploader

  validates :title, presence: true
  validates :content, presence: true

  scope :drafts, -> { where("status = 'draft'") }
  scope :not_drafts, -> { where("status != 'draft'") }
  scope :reviews, -> { where("status = 'review'") }

  scope :sort_by_creator, -> { includes(:creator).order("users.last_name, users.first_name, users.middle_name") }
  scope :sort_by_created_at, -> { order(:reviewed_at, :created_at) }
  scope :sort_by_region, -> { includes(:region).order("regions.name") }
  scope :sort_by_status, -> { order(:status) }

  aasm column: :status do
    state :draft, initial: true
    state :review
    state :approved
    state :declined

    event :submit do
      transitions from: :draft, to: :review
    end

    event :approve do
      transitions from: :review, to: :approved
    end

    event :decline do
      transitions from: :review, to: :declined
    end
  end

  def draft?
    created_at.present? && status == "draft"
  end

  def status_in_words
    statuses = {
      draft: "Черновик",
      review: "На рассмотрении",
      approved: "Утвержден",
      declined: "Отклонен"
    }

    statuses[status.to_sym]
  end
end
