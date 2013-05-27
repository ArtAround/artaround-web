Artaround::Application.routes.draw do
  resources :arts do
    post :comment, :on => :member
    post :submit, :on => :member
    post :add_photo, :on => :member
    post :flag, :on => :member
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

  match "/admin" => "admin/arts#index", :as => "admin"

  match "/contact" => "home#contact"
  match "/about" => "home#about"
  match "/faq" => "home#faq"

  match "/contact/send" => "home#send_contact", :via => [:post], :as => "send_contact"

  match "/map" => "home#map"
  match "/events/:slug" => "home#map"
  match "/autocomplete_categories" => "home#autocomplete_categories"

  root :to => "home#index"
end
