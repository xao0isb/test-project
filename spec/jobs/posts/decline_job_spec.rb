# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::DeclineJob do
  let(:post) { create(:post) }

  before do
    post.submit!
  end

  it "declines" do
    expect { Delayed::Job.enqueue described_class.new(post) }.to change(post, :status).to "declined"
  end
end
