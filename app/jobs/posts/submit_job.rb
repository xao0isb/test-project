# frozen_string_literal: true

module Posts
  SubmitJob = Struct.new(:post) do
    def perform
      post.submit!
    end
  end
end
