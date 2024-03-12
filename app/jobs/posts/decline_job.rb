# frozen_string_literal: true

module Posts
  DeclineJob = Struct.new(:post) do
    def perform
      return unless post.decline!

      post.update_attribute(:reviewed_at, Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
