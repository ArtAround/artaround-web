Artaround::Application.routes.draw do |map|
  resources :arts do
    post :comment, :on => :member
    post :submit, :on => :member
  end
  
  match "/contact" => "home#contact"
  root :to => "home#index"
end