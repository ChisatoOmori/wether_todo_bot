Rails.application.routes.draw do
  get 'blogs/index'
  post '/callback' => 'linebot#callback'
  root to: 'blogs#index'
  resources :blogs
end

