Artaround::Application.routes.draw do
  resources :arts do
    post :comment, :on => :member
    post :submit, :on => :member
    post :add_photo, :on => :member
  end
  
  namespace :admin do
    resources :arts do
      resources :comments do
        post :unapprove, :on => :member
      end
    end
  end
  
  namespace :api do
    scope '/v1' do
      resources :arts
      match "/neighborhoods" => "arts#neighborhoods_api"
      match "/categories" => "arts#categories_api"
    end
  end
  
  match "/admin" => "admin/arts#login", :as => "admin"
  
  match "/contact" => "home#contact"
  match "/about" => "home#about"
  match "/faq" => "home#faq"
  
  match "/contact/send" => "home#send_contact", :via => [:post], :as => "send_contact"
  
  root :to => "home#index"
end