require "spec_helper"

describe Art do
  it "has a valid factory" do
    FactoryGirl.create(:art).should be_valid
  end

  it "is invalid without a title" do
    FactoryGirl.build(:art, :title => nil).should_not be_valid
  end

  it "requires a location on create " do
    FactoryGirl.build(:art, :location => nil).should_not be_valid
  end

  describe "#apply_submission" do
    it "applies submission changes to the art" do
      art = create_approved_art
      submission = art.submissions.create(tag: ['modern', 'classic'],
                                          artist: 'An artist',
                                          category: ['Architecture'],
                                          year: 2017,
                                          location_description: 'Location description',
                                          description: 'Art description')
      art.apply_submission submission
      expect(art.tag).to                  eq(submission.tag)
      expect(art.artist).to               eq(submission.artist)
      expect(art.category).to             eq(submission.category)
      expect(art.year).to                 eq(submission.year)
      expect(art.description).to          eq(submission.description)
      expect(art.location_description).to eq(submission.location_description)
    end
  end

end
