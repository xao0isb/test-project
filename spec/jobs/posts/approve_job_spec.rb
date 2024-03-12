# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::ApproveJob do
  let(:post) { create(:post) }

  before do
    post.submit!
  end

  it "approves" do
    Delayed::Job.enqueue described_class.new(post)

    expect(post.reload.status).to eq("approved")
    expect(post.reload.reviewed_at).not_to be_nil
  end
end
