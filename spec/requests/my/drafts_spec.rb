# frozen_string_literal: true

require "rails_helper"

RSpec.describe "My drafts" do
  let(:current_user) { create(:user) }

  context "when user does not authenticated" do
    describe "GET /show" do
      it "redirects to sign in page" do
        get my_drafts_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  context "when user authenticated" do
    before do
      login_as(current_user)
    end

    describe "GET /show" do
      it "returns http success" do
        get my_drafts_url
        expect(response).to have_http_status(:success)
      end
    end
  end
end
