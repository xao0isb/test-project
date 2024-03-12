# frozen_string_literal: true

require "rails_helper"

RSpec.describe Region do
  context "with invalid attributes" do
    it "does not create" do
      expect(described_class.new).not_to be_valid
    end
  end

  context "with valid attributes" do
    let(:attributes) { { name: "Oregon" } }

    it "creates" do
      expect(described_class.new(attributes)).to be_valid
    end
  end
end
