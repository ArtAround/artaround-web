Artaround::Application.routes.draw do
  resources :arts do
    post :comment, :on => :member
    post :submit, :on => :member
    post :add_photo, :on => :member
    post :flag, :on => :member
    get :index, :on => :collection
  end

  namespace :admin do
    resources :arts do
      resources :comments do
        post :unapprove, :on => :member
        post :approve, :on => :member
      end
      resources :photos
    end
    resources :events
    resources :commissioners
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
    end
  end

  match "/new_art_photo" => "arts#new_art_photo", :as => "new_art_photo"
  match "/create_art_photo" => "arts#create_art_photo", :as => "create_art_photo"

  match "/admin" => "admin/arts#index", :as => "admin"

  match "/contact" => "home#contact"
  match "/about" => "home#about"
  match "/faq" => "home#faq"

  match "/contact/send" => "home#send_contact", :via => [:post], :as => "send_contact"

  match "/map" => "home#map"
  match "/events/:slug" => "home#map"
  match "/autocomplete_commissioners" => "home#autocomplete_commissioners"

  root :to => "home#map"
end
