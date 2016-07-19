describe SubmissionsController do
  describe 'POST /approve' do

    it "redirects to art on successful approval" do
      art = create_approved_art
      submission = art.submissions.create(tag: 'tag')
      post :approve, art_id: art.slug, id: submission.id
      expect(response).to redirect_to(art_path(art))
    end

    xit "approves submissions" do
      art = create_approved_art
      submission = art.submissions.create(tag: 'tag')
      post :approve, art_id: art.slug, id: submission.id
      updated_art = Art.find_by_slug(art.slug)
      expect(updated_art.tag).to eq('tag')
    end
  end
end
