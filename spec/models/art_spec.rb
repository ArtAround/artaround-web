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

end
