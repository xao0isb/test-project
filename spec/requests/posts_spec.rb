# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Posts" do
  let(:current_user) { create(:user) }
  let(:creator) { current_user }
  let(:post_) { create(:post, creator:) }
  let(:params) do
    {
      post: {
        user_id: creator.id,
        title: "Post title",
        content: "Post content...",
        region_id: creator.region.id
      }
    }
  end
  let(:invalid_params) do
    {
      post: {
        user_id: creator.id,
        title: nil,
        content: nil,
        region_id: creator.region.id
      }
    }
  end

  let(:new_params) do
    params[:post][:title] = "Updated title"

    params
  end
  let(:invalid_new_params) { invalid_params }

  context "when user does not authenticated" do
    describe "GET /index" do
      it "redirects to sign in page" do
        get posts_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "GET /show" do
      it "redirects to sign in page" do
        get post_url(post_)
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "GET /new" do
      it "redirects to sign in page" do
        get new_post_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "POST /create" do
      it "returns 401" do
        post(posts_url, params:)

        expect(response).to have_http_status(:unauthorized)
      end

      it "does not create" do
        expect { post(posts_url, params:) }.not_to change(Post, :count)
      end
    end

    describe "GET /edit" do
      it "redirects to sign in page" do
        get edit_post_url(post_)
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "PATCH /update" do
      it "returns 401" do
        patch(post_url(post_, params: new_params))

        expect(response).to have_http_status(:unauthorized)
      end

      it "does not update" do
        patch(post_url(post_, params: new_params))

        expect(post_.reload.title).not_to eq(new_params[:post][:title])
      end
    end

    describe "PATCH /approve" do
      it "returns 401" do
        patch(approve_post_url(post_))

        expect(response).to have_http_status(:unauthorized)
      end

      it "does not approve" do
        expect { patch(approve_post_url(post_)) }.not_to(change { post_.reload.status })
      end
    end

    describe "PATCH /decline" do
      it "returns 401" do
        patch(decline_post_url(post_))

        expect(response).to have_http_status(:unauthorized)
      end

      it "does not decline" do
        patch(decline_post_url(post_))

        expect(post_.reload.status).not_to be("declined")
        expect(post_.reload.reviewed_at).to be_nil
      end
    end
  end

  context "when user authenticated" do
    before do
      login_as(current_user)
    end

    describe "GET /index" do
      it "returns http success" do
        get posts_url
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET /show" do
      it "returns http success" do
        get post_url(post_)
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET /new" do
      it "returns http success" do
        get new_post_url
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST /create" do
      context "with valid params" do
        it "creates" do
          expect { post(posts_url, params:) }.to change(Post, :count).by(1)
        end

        it "creates with right parameters" do
          post(posts_url, params:)

          post_ = Post.last

          expect(post_.status).to eq("review")
          expect(post_.creator.id).to eq(params[:post][:user_id])
          expect(post_.title).to eq(params[:post][:title])
          expect(post_.content).to eq(params[:post][:content])
          expect(post_.region.id).to eq(params[:post][:region_id])
        end

        it "redirects to post page" do
          post(posts_url, params:)

          expect(response).to redirect_to(post_url(Post.last))
        end
      end

      context "with invalid params" do
        it "returns unprocessable entity" do
          post(posts_url, params: invalid_params)

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "redirects to new" do
          post(posts_url, params: invalid_params)

          expect(response).to render_template(:new)
        end

        it "does not create" do
          expect { post(posts_url, params: invalid_params) }.not_to change(Post, :count)
        end
      end
    end

    describe "GET /edit" do
      it "eturns http success" do
        get edit_post_url(post_)
        expect(response).to have_http_status(:success)
      end
    end

    describe "PATCH /update" do
      context "with valid params" do
        it "updates" do
          patch(post_url(post_, params: new_params))

          expect(post_.reload.title).to eq(new_params[:post][:title])
        end

        it "redirects to post page" do
          patch(post_url(post_, params: new_params))

          expect(response).to redirect_to(post_url(Post.last))
        end
      end

      context "with invalid params" do
        it "returns unprocessable entity" do
          patch(post_url(post_, params: invalid_new_params))

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "redirects to new" do
          patch(post_url(post_, params: invalid_new_params))

          expect(response).to render_template(:edit)
        end

        it "does not update" do
          expect { patch(post_url(post_, params: invalid_new_params)) }
            .not_to change(post_.reload, :title)
        end
      end

      context "when new region was set" do
        before do
          another_region = create(:region)

          new_params[:post][:region_id] = another_region.id
        end

        describe "PATCH /update" do
          it "returns 403" do
            patch(post_url(post_, params: new_params))

            expect(response).to have_http_status(:forbidden)
          end

          it "does not update" do
            patch(post_url(post_, params: new_params))

            expect(post_.reload.title).not_to eq(new_params[:post][:title])
          end
        end
      end
    end

    context "when current user is not creator" do
      before do
        another_user = create(:user)

        post_.creator = another_user
        post_.save

        params[:post][:user_id] = another_user.id
      end

      describe "POST /create" do
        it "returns 403" do
          post(posts_url, params:)

          expect(response).to have_http_status(:forbidden)
        end

        it "does not create" do
          expect { post(posts_url, params:) }.not_to change(Post, :count)
        end
      end

      describe "PATCH /update" do
        it "returns 403" do
          patch(post_url(post_, params: new_params))

          expect(response).to have_http_status(:forbidden)
        end

        it "does not update" do
          patch(post_url(post_, params: new_params))

          expect(post_.reload.title).not_to eq(new_params[:post][:title])
        end
      end
    end

    context "when region is not region of current user" do
      before do
        another_region = create(:region)

        post_.region = another_region
        post_.save

        params[:post][:region_id] = another_region.id
      end

      describe "POST /create" do
        it "returns 403" do
          post(posts_url, params:)

          expect(response).to have_http_status(:forbidden)
        end

        it "does not create" do
          expect { post(posts_url, params:) }.not_to change(Post, :count)
        end
      end

      describe "PATCH /update" do
        it "returns 403" do
          patch(post_url(post_, params: new_params))

          expect(response).to have_http_status(:forbidden)
        end

        it "does not update" do
          patch(post_url(post_, params: new_params))

          expect(post_.reload.title).not_to eq(new_params[:post][:title])
        end
      end
    end
  end

  context "when user is admin" do
    let(:admin) { create(:user, role: :admin) }

    before do
      login_as(admin)

      params[:post][:user_id] = admin.id
    end

    describe "POST /create" do
      it "creates with approved status" do
        post(posts_url, params:)

        post_ = Post.last

        expect(post_.status).to eq("approved")
        expect(post_.reviewed_at).not_to be_nil
      end
    end

    describe "PATCH /approve" do
      before do
        post_.submit!
      end

      it "approves" do
        patch(approve_post_url(post_))

        expect(post_.reload.status).to eq("approved")
        expect(post_.reload.reviewed_at).not_to be_nil
      end

      context "when not admin" do
        before do
          login_as(current_user)
        end

        it "does not approve" do
          patch(approve_post_url(post_))

          expect(post_.reload.status).not_to eq("approved")
          expect(post_.reload.reviewed_at).to be_nil
        end
      end
    end

    describe "PATCH /decline" do
      before do
        post_.submit!
      end

      it "declines" do
        patch(decline_post_url(post_))

        expect(post_.reload.status).to eq("declined")
        expect(post_.reload.reviewed_at).not_to be_nil
      end

      context "when not admin" do
        before do
          login_as(current_user)
        end

        it "does not decline" do
          patch(decline_post_url(post_))

          expect(post_.reload.status).not_to be("declined")
          expect(post_.reload.reviewed_at).to be_nil
        end
      end
    end
  end
end
