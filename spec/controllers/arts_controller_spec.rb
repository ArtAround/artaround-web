require 'spec_helper'

describe ArtsController do
  describe "POST /submit" do
    it "does not write directly to the art itself" do
      art = create_approved_art
      post :submit, id: art.slug, submission: {tag: 'tag'}
      updated_art = Art.find(art.id)
      expect(updated_art.tag).to be(nil)
      expect(updated_art.submissions.length).to eq(1)
      expect(updated_art.submissions.first.tag).to eq('tag')
    end
  end

  def create_approved_art title='The Bean'
    art = Art.create title: 'The Bean',
      address: '360 S Water',
      state: 'IL',
      city: 'Chicago',
      approved: true
    art.approved = true
    art.save!
    art
  end
end
