require 'spec_helper'

describe "retrieving an art", :type => :feature do

  before :each do
    @art = FactoryGirl.create(:art)
    @primary_photo = FactoryGirl.create(:photo, :primary => true, :art => @art)
  end

  after :each do
    @art.destroy
  end

  it "should get art info" do
    visit("/api/v1/arts/" + @art.slug)
    page.should have_content(@art.artist)
    page.should have_content(@art.year)
    page.should have_content(@art.description)
    page.should have_content(@art.location_description)
  end

  it "should get all art categories" do
    visit("/api/v1/arts/" + @art.slug)
    @art.category.each do |cat|
      page.should have_content(cat)
    end
  end

end
