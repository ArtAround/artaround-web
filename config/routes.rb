Artaround::Application.routes.draw do |map|
  resources :arts
  
  root :to => "home#index"
end