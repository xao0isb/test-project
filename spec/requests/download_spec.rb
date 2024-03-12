# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Download" do
  let(:user) { create(:user) }
  let(:post_) { create(:post) }
  let(:params) { { post_id: post_.id, file_path: Rails.root.join("Gemfile").to_s } }

  context "when user does not authenticated" do
    describe "POST /file" do
      it "returns 401" do
        post(download_file_url, params:)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context "when user authenticated" do
    before do
      login_as(user)
    end

    describe "POST /file" do
      it "redirects back to post" do
        post(download_file_url, params:)

        expect(response).to redirect_to(post_)
      end
    end
  end
end
