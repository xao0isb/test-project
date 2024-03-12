# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Reports" do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: :admin) }
  let(:posts) { create_list(:post, 3) }
  let(:params) { { post_ids: posts.map(&:id) } }

  context "when user does not authenticated" do
    describe "POST /excel" do
      it "returns 401" do
        post(reports_excel_url, params:)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context "when user authenticated" do
    before do
      login_as(admin)
    end

    context "when user is not admin" do
      before do
        login_as(user)
      end

      describe "POST /excel" do
        it "returns 403" do
          post(reports_excel_url, params:)

          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
