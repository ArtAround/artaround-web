require 'spec_helper'

describe Admin::SubmissionsController do
  describe 'POST /approve' do
    it "redirects to art on successful approval" do
      art = create_approved_art
      submission = art.submissions.create(tag: ['tag'])
      get :approve, art_id: art.slug, id: submission.id
      expect(response).to redirect_to(art_path(art))
    end

    it "approves submissions" do
      art = create_approved_art
      submission = art.submissions.create(tag: ['tag'])
      get :approve, art_id: art.slug, id: submission.id
      updated_art = Art.find_by_slug(art.slug)
      expect(updated_art.tag).to eq(['tag'])
    end
  end

  describe "DELETE /destroy" do
    it "redirects to art on successful deletion" do
      art = create_approved_art
      submission = art.submissions.create(tag: ['tag'])
      delete :destroy, art_id: art.slug, id: submission.id
      expect(response).to redirect_to(art_path(art))
    end

    it "deletes the submission from the system" do
      art = create_approved_art
      submission = art.submissions.create(tag: ['tag'])
      delete :destroy, art_id: art.slug, id: submission.id
      expect(Submission.where(id: submission.id).count).to eq(0)
    end
  end
end
