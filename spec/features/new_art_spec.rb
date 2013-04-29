require "spec_helper"

describe "uploading a piece of art", :type => :feature do
  it "works" do
    visit '/arts/new'
    select "Mural", :from => "category"
    fill_in "art_title", :with => "Ping Pong"
    fill_in "art_artist", :with => "Daffy Duck"
    fill_in "art_year", :with => "1989"
    select "Bellevue", :from => "neighborhood"

    fill_in "art_latitude", :with => "38.91220703817357"
    fill_in "art_longitude", :with => "-77.0451021194458"

    attach_file "new_photo", Rails.root.join("spec", "assets", "photo.jpg")
    fill_in "photo_attribution_text", :with => "Droopy Dog"
    fill_in "photo_attribution_url", :with => "www.droopydog.com"

    click_on "Submit"


    page.should have_content("Thanks for contributing a new piece of art!")
    page.should have_content("#{I18n.t :photo_by} Droopy Dog")
    find_link('Droopy Dog')[:href].should == 'www.droopydog.com'

    Art.where(:title => "Ping Pong").destroy
  end
end
