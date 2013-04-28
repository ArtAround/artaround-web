require "spec_helper"


describe "viewing an art", :type => :feature, :js => true do

  before :each do
    @art = FactoryGirl.create(:art)
    @primary_photo = FactoryGirl.create(:photo, :primary => true, :art => @art)
  end

  after :each do
    @art.destroy
  end

  it "displays the art info" do
    visit @art.url
    page.should have_content(@art.title.upcase)
    page.should have_content(@art.category)
    page.should have_content(@art.artist)
    page.should have_content(@art.year)
    page.should have_content(@art.description)
    page.should have_content(@art.location_description)
  end

  it "displays the primary photo and attribution" do
    visit @art.url
    image_url = find(:xpath, "//a[@id='artworkPhoto']/img")[:src]
    image_url.should have_content(@primary_photo.image.url(:big))
    page.should have_content("Photo by #{@primary_photo.attribution_text}")
    find_link(@primary_photo.attribution_text)[:href].should == @primary_photo.attribution_url
  end
end
