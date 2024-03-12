# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins" do
  let(:admin) { create(:user, role: :admin) }
  let(:new_admin) { create(:user) }
  let(:params) { { id: new_admin.id } }

  before do
    login_as(admin)
  end

  context "when user does not authenticated" do
    before do
      logout
    end

    describe "GET /new" do
      it "redirects to sign in page" do
        get new_admin_url

        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "POST /create" do
      it "returns 401" do
        post(admins_url, params:)

        expect(response).to have_http_status(:unauthorized)
      end

      it "does not create" do
        expect { post(admins_url, params:) }.not_to change(new_admin, :role)
      end
    end
  end

  context "when user is not admin" do
    let(:user) { create(:user) }

    before do
      login_as(user)
    end

    describe "GET /new" do
      it "returns 403" do
        get new_admin_url
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "POST /create" do
      it "returns 403" do
        post(admins_url, params:)

        expect(response).to have_http_status(:forbidden)
      end

      it "does not create" do
        expect { post(admins_url, params:) }.not_to(change { new_admin.reload.role })
      end
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_admin_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "creates" do
      expect { post(admins_url, params:) }.to change { new_admin.reload.role }.to("admin")
    end
  end
end
