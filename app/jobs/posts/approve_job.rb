# frozen_string_literal: true

module Posts
  ApproveJob = Struct.new(:post) do
    def perform
      return unless post.approve!

      post.update_attribute(:reviewed_at, Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
