# frozen_string_literal: true

require "rails_helper"

RSpec.describe Post do
  context "with invalid attributes" do
    it "does not create" do
      expect(described_class.new).not_to be_valid
    end
  end

  context "with valid attributes" do
    let(:creator) { User.new(region: Region.new) }
    let(:attributes) do
      {
        creator:,
        title: "Post title",
        content: "Post content...",
        region: creator.region
      }
    end

    it "creates" do
      expect(described_class.new(attributes)).to be_valid
    end
  end

  describe ".draft?" do
    let(:draft) { create(:post) }

    it "returns true" do
      expect(draft.draft?).to be(true)
    end
  end

  describe ".status_in_words" do
    let(:draft) { create(:post) }
    let(:review) { create(:post, status: :review) }
    let(:approved) { create(:post, status: :approved) }
    let(:declined) { create(:post, status: :declined) }

    it "returns correct statuses" do
      expect(draft.status_in_words).to eq("Черновик")
      expect(review.status_in_words).to eq("На рассмотрении")
      expect(approved.status_in_words).to eq("Утвержден")
      expect(declined.status_in_words).to eq("Отклонен")
    end
  end

  describe "scopes" do
    let!(:draft_post) { create(:post, status: "draft") }
    let!(:review_post) { create(:post, status: "review") }
    let!(:approve_post) { create(:post, status: "approved") }

    describe "drafts" do
      it "returns only drafts" do
        res = described_class.drafts

        expect(res).to eq([draft_post])
      end
    end

    describe "not_drafts" do
      it "returns not drafts" do
        res = described_class.not_drafts

        expect(res).to eq([review_post, approve_post])
      end
    end

    describe "reviews" do
      it "returns only reviews" do
        res = described_class.reviews

        expect(res).to eq([review_post])
      end
    end
  end

  describe "states" do
    let(:post) { described_class.new }

    it "draft as default state" do
      expect(post).to have_state(:draft)
    end

    it "review" do
      post.submit

      expect(post).to have_state(:review)
    end

    it "approved" do
      post.submit
      post.approve

      expect(post).to have_state(:approved)
    end

    it "declined" do
      post.submit
      post.decline

      expect(post).to have_state(:declined)
    end
  end
end
