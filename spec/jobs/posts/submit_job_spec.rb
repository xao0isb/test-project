# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::SubmitJob do
  let(:post) { create(:post) }

  it "submits" do
    expect { Delayed::Job.enqueue described_class.new(post) }.to change(post, :status).to "review"
  end
end
