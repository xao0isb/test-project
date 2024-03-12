# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Drafts" do
  let(:current_user) { create(:user) }
  let(:creator) { current_user }
  let(:draft) { create(:post, creator:) }
  let(:params) do
    {
      post: {
        user_id: creator.id,
        title: "Draft title",
        content: "Draft content...",
        region_id: creator.region.id
      }
    }
  end
  let(:delete_params) do
    {
      id: draft.id
    }.merge(params)
  end

  context "when user does not authenticated" do
    describe "POST /create" do
      it "returns 401" do
        post(drafts_url, params:)

        expect(response).to have_http_status(:unauthorized)
      end

      it "does not create" do
        expect { post(drafts_url, params:) }.not_to change(creator.posts.drafts, :count)
      end
    end

    describe "POST /submit" do
      it "returns 401" do
        post(submit_draft_url(draft))

        expect(response).to have_http_status(:unauthorized)
      end

      it "does not submit" do
        post(submit_draft_url(draft))

        expect(draft.reload.status).not_to eq("review")
      end
    end

    describe "DELETE /destroy" do
      it "returns 401" do
        delete(draft_url(draft))

        expect(response).to have_http_status(:unauthorized)
      end

      it "does not delete" do
        # generate since let() is lazy
        draft

        expect { delete(draft_url(draft)) }.not_to change(creator.posts.drafts, :count)
      end
    end
  end

  context "when user authenticated" do
    before do
      login_as(current_user)
    end

    describe "POST /create" do
      context "with valid params" do
        it "creates" do
          expect { post(drafts_url, params:) }.to change(creator.posts.drafts, :count).by(1)
        end

        it "creates with right parameters" do
          post(drafts_url, params:)

          draft = creator.posts.drafts.last

          expect(draft.status).to eq("draft")
          expect(draft.creator.id).to eq(params[:post][:user_id])
          expect(draft.title).to eq(params[:post][:title])
          expect(draft.content).to eq(params[:post][:content])
          expect(draft.region.id).to eq(params[:post][:region_id])
        end

        it "redirects to post page" do
          post(drafts_url, params:)

          expect(response).to redirect_to(post_url(creator.posts.drafts.last))
        end
      end

      context "with invalid params" do
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

        it "does not create" do
          expect { post(drafts_url, params: invalid_params) }.not_to change(creator.posts.drafts, :count)
        end

        it "redirects to new post page" do
          post(drafts_url, params: invalid_params)

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "POST /submit" do
      it "submits" do
        post(submit_draft_url(draft))

        expect(draft.reload.status).to eq("review")
      end

      it "redirects to post page" do
        post(submit_draft_url(draft))

        expect(response).to redirect_to(post_url(draft))
      end
    end

    describe "DELETE /destroy" do
      it "redirects to my drafts" do
        delete(draft_url(draft))

        expect(response).to redirect_to(my_drafts_url)
      end

      it "deletes" do
        # generate since let() is lazy
        draft

        expect { delete(draft_url(draft)) }.to change(creator.posts.drafts, :count).by(-1)
      end

      describe "when post status different than draft" do
        before do
          draft.submit!
        end

        it "returns 403" do
          delete(draft_url(draft))

          expect(response).to have_http_status(:forbidden)
        end

        it "does not delete" do
          expect { delete(draft_url(draft)) }.not_to change(creator.posts.drafts, :count)
        end
      end
    end

    context "when creator is not current user" do
      before do
        another_user = create(:user)
        params[:post][:user_id] = another_user.id
      end

      describe "POST /create" do
        it "returns 403" do
          post(drafts_url, params:)

          expect(response).to have_http_status(:forbidden)
        end

        it "does not create" do
          expect { post(drafts_url, params:) }.not_to change(creator.posts.drafts, :count)
        end
      end
    end

    context "when user is not creator" do
      before do
        another_user = create(:user)
        login_as(another_user)
      end

      describe "POST /submit" do
        it "returns 403" do
          post(submit_draft_url(draft))

          expect(response).to have_http_status(:forbidden)
        end

        it "does not submit" do
          post(submit_draft_url(draft))

          expect(draft.reload.status).not_to eq("review")
        end
      end

      describe "DELETE /destroy" do
        it "returns 403" do
          delete(draft_url(draft))

          expect(response).to have_http_status(:forbidden)
        end

        it "does not delete" do
          # generate since let() is lazy
          draft

          expect { delete(draft_url(draft)) }.not_to change(creator.posts.drafts, :count)
        end
      end
    end

    context "when region is not region of current user" do
      before do
        another_region = create(:region)
        params[:post][:region_id] = another_region.id
      end

      describe "POST /create" do
        it "returns 403" do
          post(drafts_url, params:)

          expect(response).to have_http_status(:forbidden)
        end

        it "does not create" do
          expect { post(drafts_url, params:) }.not_to change(creator.posts.drafts, :count)
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

    describe "POST /submit" do
      let(:admin_draft) { create(:post, status: :draft, creator: admin) }

      it "submits" do
        post(submit_draft_url(admin_draft))

        expect(admin_draft.reload.status).to eq("approved")
      end

      it "redirects to post page" do
        post(submit_draft_url(admin_draft))

        expect(response).to redirect_to(post_url(admin_draft))
      end
    end

    context "when draft has different region" do
      before do
        region = create(:region)
        params[:post][:region_id] = region.id
      end

      describe "POST /create" do
        it "creates" do
          expect { post(drafts_url, params:) }.to change(admin.posts.drafts, :count).by(1)
        end

        it "creates with right parameters" do
          post(drafts_url, params:)

          draft = admin.posts.drafts.last

          expect(draft.status).to eq("draft")
          expect(draft.creator.id).to eq(params[:post][:user_id])
          expect(draft.title).to eq(params[:post][:title])
          expect(draft.content).to eq(params[:post][:content])
          expect(draft.region.id).to eq(params[:post][:region_id])
        end

        it "redirects to post page" do
          post(drafts_url, params:)

          expect(response).to redirect_to(post_url(admin.posts.drafts.last))
        end
      end
    end
  end
end
