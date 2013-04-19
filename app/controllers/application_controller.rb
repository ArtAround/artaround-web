class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "application"
  
  # saves the art, creates a photo and saves it, returns the Photo object
  def create_photo(art, image, attribution_text = nil, attribution_url = nil)
    art.photos.new(
      :attribution_text => attribution_text,
      :attribution_url => attribution_url,
      :image => image
    )
  end
  
  helper_method :admin?
  def admin?
    session[:admin] == true
  end
  
  helper_method :recent_art
  def recent_art
    @recent_art ||= Art.approved.descending(:created_at).limit(5).to_a
  end
  
  helper_method :categories
  def categories
    @categories ||= ["Architecture", "Gallery", "Market", "Memorial", "Mosaic", "Mural", "Museum", "Painting", "Paste", "Sculpture", "Statue", "Temporary"]
  end
  
  helper_method :neighborhoods
  def neighborhoods
    @neighborhoods ||= ["Adams Morgan",  "American University Park", "Anacostia",  "Arboretum",  "Barnaby Woods",  "Barney Circle",  "Barry Farm", "Bellevue", "Benning",  "Benning Heights",  "Benning Ridge",  "Berkley",  "Bloomingdale", "Brentwood",  "Brightwood", "Brightwood Park",  "Brookland",  "Buena Vista",  "Burleith", "Burrville",  "Capitol Hill", "Capitol View", "Carver Langston",  "Cathedral Heights",  "Chevy Chase", "Chinatown",  "Civic Betterment", "Cleveland Park", "Colonial Village", "Colony Hill",  "Columbia Heights", "Congress Heights", "Crestwood",  "Deanwood", "Douglass", "Downtown", "Dupont Circle",  "Dupont Park",  "East Potomac Park", "Eastland Gardens", "Eckington",  "Edgewood", "Fairfax Village",  "Fairlawn", "Fairlawn", "Foggy Bottom", "Forest Hills", "Fort Davis", "Fort Dupont",  "Fort Lincoln", "Fort Totten",  "Foxhall",  "Friendship Heights", "Garfield Heights", "Gateway",  "Georgetown", "Glover Park",  "Good Hope",  "Grant Park", "Greenway", "H Street Corridor", "Hawthorne",  "Hillbrook",  "Hillcrest",  "Ivy City", "Judiciary Square", "Kalorama", "Kenilworth", "Kent", "Kingman Park", "Kingman Park", "Knox Hill",  "Lamond-Riggs", "Langdon",  "LeDroit Park", "Lincoln Heights",  "Logan Circle", "Mahaning Heights", "Manor Park", "Marshall Heights", "Massachusetts Heights",  "Mayfair",  "McLean Gardens", "Michigan Park",  "Mount Pleasant", "Mount Vernon Square",  "Navy Yard/Near Southeast", "Naylor Gardens", "Near Northeast", "NoMa, Washington, D.C.", "North Cleveland Park", "North Michigan Park",  "Observatory Circle", "Park View",  "Penn Branch",  "Penn Quarter", "Petworth", "Pleasant Hill",  "Pleasant Plains",  "Potomac Heights",  "Randle Highlands", "Riggs Park", "River Terrace",  "Shaw", "Shepherd Park",  "Sheridan Kalorama",  "Shipley Terrace",  "Sixteenth Street Heights", "Skyland",  "Southwest Federal Center", "Southwest Waterfront", "Spring Valley",  "Stronghold/Metropolis View", "Summit Park",  "Sursum Corda", "Swampoodle", "Takoma", "Tenleytown", "The Palisades",  "Thomas Circle", "Trinidad", "Truxton Circle", "Twining",  "Union Station",  "Wakefield",  "Washington Highlands", "Wesley Heights", "West End", "Woodland", "Woodley Park", "Woodridge"]
  end
end
