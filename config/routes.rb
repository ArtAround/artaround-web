Artaround::Application.routes.draw do
  resources :arts do
    post :comment, :on => :member
    post :submit, :on => :member
    post :add_photo, :on => :member
  end
  
  match "/contact" => "home#contact"
  match "/about" => "home#about"
  match "/faq" => "home#faq"
  
  match "/contact/send" => "home#send_contact", :via => [:post], :as => "send_contact"
  
  root :to => "home#index"
end