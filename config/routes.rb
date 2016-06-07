Artaround::Application.routes.draw do
  resources :arts do
    post :comment, :on => :member
    post :submit, :on => :member
    post :add_photo, :on => :member
    post :flag, :on => :member
    get :index, :on => :collection
    post :manage_link ,:on => :collection
    get :destroy_link, :on => :member
    
    
  end

  namespace :admin do
    resources :arts do
      resources :comments do
        post :delete, :on => :member
        post :unapprove, :on => :member
        post :approve, :on => :member
      end
      resources :photos
      post :manage_link ,:on => :collection
      get :destroy_link, :on => :member
    end

    resources :tags
    resources :artists
    resources :countries
    resources :events
    resources :commissioners
    get 'tag/:id' => 'tags#destroy', as: :trash_tag
    get 'artist/:id' => 'artists#destroy', as: :trash_artist
    get 'country/:id' => 'countries#destroy', as: :trash_country
  end

  namespace :api do
    scope '/v1' do
      resources :arts, :except => [:new, :edit] do
        member do
          post :photos
          post :comments
        end
      end

      match "/neighborhoods" => "arts#neighborhoods_api"
      match "/categories" => "arts#categories_api"
      match "/tags" => "arts#tags_api"
    end
  end

  match "/new_art_photo" => "arts#new_art_photo", :as => "new_art_photo"
  match "/create_art_photo" => "arts#create_art_photo", :as => "create_art_photo"

  match "/admin" => "admin/arts#index", :as => "admin"

  match "/contact" => "home#contact"
  match "/about" => "home#about"
  match "/faq" => "home#faq"

  match "/contact/send" => "home#send_contact", :via => [:post], :as => "send_contact"

  match "/map" => "arts#map", :as => "map"
  match "/events/:slug" => "arts#map"
  match "/autocomplete_commissioners" => "home#autocomplete_commissioners"

  get "/tag/:id" => "tag#show" ,:as => "tag"
  get "/artist/:id" => "artist#show" ,:as => "artist"
  get "/category/:id" => "category#show" ,:as => 'category'
  root :to => "arts#index"
end
