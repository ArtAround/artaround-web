require "spec_helper"

describe Photo do
  describe "attributes" do
    it "saves the url as a valid http url" do
      p = FactoryGirl.create(:photo, :attribution_url => "www.example.com")
      p.attribution_url.should == "http://www.example.com"
      p.update_attributes({:attribution_url => "https://rubymine.org"})
      p.attribution_url.should == "https://rubymine.org"
    end
  end

  it "substitutes the attribution url, if any, for missing attribution text" do
    p = FactoryGirl.create(:photo, :attribution_text => "", :attribution_url => "www.example.com")
    p.attribution_text.should == "http://www.example.com"
  end

  it "sets the attribution text to anonymous user if both the attribution text and url are missing" do
    p = FactoryGirl.create(:photo, :attribution_text => "", :attribution_url => "")
    p.attribution_text.should == "anonymous user"
  end

end
