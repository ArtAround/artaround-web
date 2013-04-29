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
    page.should have_content("#{I18n.t :photo_by} #{@primary_photo.attribution_text}")
    find_link(@primary_photo.attribution_text)[:href].should == @primary_photo.attribution_url
  end

  it "displays additional photos as thumbnails and switches to those photos if clicked" do
    secondary_photo = FactoryGirl.create(:photo, :art => @art,
                                         :image => File.new(Rails.root + 'spec/assets/photo2.jpg'),
                                         :attribution_text => "Peppermint Patty",
                                         :attribution_url => "http://www.peppy.net/",
                                         :primary => false
    )
    @art.save!

    visit @art.url
    page.should have_xpath("//img[@src='#{secondary_photo.image.url(:small)}']")
    page.should_not have_content("#{I18n.t :photo_by} #{secondary_photo.attribution_text}")

    find(:xpath, "//img[@src='#{secondary_photo.image.url(:small)}']").click

    page.should have_xpath("//img[@src='#{secondary_photo.image.url(:big)}']")
    page.should have_content("#{I18n.t :photo_by} #{secondary_photo.attribution_text}")
    find_link(secondary_photo.attribution_text)[:href].should == secondary_photo.attribution_url
  end

  it "updates the attribution correctly when switching to thumbnails without urls" do
    secondary_photo = FactoryGirl.create(:photo, :art => @art,
                                         :image => File.new(Rails.root + 'spec/assets/photo2.jpg'),
                                         :attribution_text => "Peppermint Patty",
                                         :attribution_url => "",
                                         :primary => false
    )
    @art.save!

    visit @art.url
    page.should have_xpath("//img[@src='#{secondary_photo.image.url(:small)}']")
    page.should_not have_content("#{I18n.t :photo_by} #{secondary_photo.attribution_text}")

    find(:xpath, "//img[@src='#{secondary_photo.image.url(:small)}']").click

    page.should have_xpath("//img[@src='#{secondary_photo.image.url(:big)}']")
    page.should have_content("#{I18n.t :photo_by} Peppermint Patty")
    page.should_not have_link("Peppermint Patty")
  end

  describe "When the photo attribution text and url are both blank" do
    before :each do
      @art = FactoryGirl.create(:art)
      @primary_photo = FactoryGirl.create(:photo, :art => @art,
                                          :image => File.new(Rails.root + 'spec/assets/photo2.jpg'),
                                          :attribution_text => nil,
                                          :attribution_url => nil,
                                          :primary => true
      )
    end

    after :each do
      @art.destroy
    end

    it "Attributes anonymous user and does not display an attribution link." do
      visit @art.url
      find(:xpath, "//img[@src='#{@primary_photo.image.url(:small)}']").click
      page.should have_xpath("//img[@src='#{@primary_photo.image.url(:big)}']")
      page.should have_content("#{I18n.t :photo_by} #{I18n.t :anonymous_user}")
      page.should_not have_link("anonymous user")
    end
  end

  describe "When the photo attribution text is blank but url is not" do
    before :each do
      @art = FactoryGirl.create(:art)
      @primary_photo = FactoryGirl.create(:photo, :art => @art,
                                          :image => File.new(Rails.root + 'spec/assets/photo2.jpg'),
                                          :attribution_text => nil,
                                          :attribution_url => "http://www.peppy.com/",
                                          :primary => true
      )
    end

    after :each do
      @art.destroy
    end

    it "Shows the attribution url as both the text and href of the link." do
      visit @art.url
      find(:xpath, "//img[@src='#{@primary_photo.image.url(:small)}']").click
      page.should have_xpath("//img[@src='#{@primary_photo.image.url(:big)}']")
      page.should have_content("#{I18n.t :photo_by} #{@primary_photo.attribution_url}")
      find_link(@primary_photo.attribution_url)[:href].should == @primary_photo.attribution_url
    end
  end
end






