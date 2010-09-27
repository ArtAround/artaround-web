Artaround::Application.routes.draw do |map|
  resources :arts
  
  match "/contact" => "home#contact"
  root :to => "home#index"
end