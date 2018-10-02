Artaround::Application.routes.draw do
  resources :arts do
    post :comment, :on => :member
    post :submit, :on => :member
    post :add_photo, :on => :member
    post :flag, :on => :member
    get :index, :on => :collection
    post :manage_link ,:on => :collection
    get :destroy_link, :on => :member
    get :filter_category, :on => :collection

  end

  namespace :admin do
    resources :stats, only:[:index] do
      collection do
        get :tags
        get :categories
        get :cities
        get :artists
      end
    end
    resources :art_imports, controller: 'arts_import', only: [:show, :new, :create]
    resources :arts do
      resources :comments do
        post :delete, :on => :member
        post :unapprove, :on => :member
        post :approve, :on => :member
      end
      resources :photos
      post :manage_link ,:on => :collection
      get :destroy_link, :on => :member
      resources :submissions, :only => [:destroy] do
        get :approve, :on => :member
      end
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

      get "/neighborhoods" => "arts#neighborhoods_api"
      get "/categories" => "arts#categories_api"
      get "/tags" => "arts#tags_api"
    end
  end

  get "/new_art_photo" => "arts#new_art_photo", :as => "new_art_photo"
  post "/create_art_photo" => "arts#create_art_photo", :as => "create_art_photo"

  get "/admin" => "admin/arts#index", :as => "admin"

  get "/contact" => "home#contact"
  get "/about" => "home#about"
  get "/faq" => "home#faq"

  post "/contact/send" => "home#send_contact", :as => "send_contact"

  get "/map" => "arts#map", :as => "map"
  get "/events/:slug" => "arts#map"
  get "/autocomplete_commissioners" => "home#autocomplete_commissioners"

  get "/tag/:id" => "tag#show" ,:as => "tag"
  get "/artist/:id" => "artist#show" ,:as => "artist"
  get "/category/:id" => "category#show" ,:as => 'category'
  root :to => "arts#index"
end
