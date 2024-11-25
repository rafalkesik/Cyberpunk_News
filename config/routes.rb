Rails.application.routes.draw do
  root 'static_pages#home'

  get  'guidelines',  to: 'static_pages#guidelines'
  get  'faq',         to: 'static_pages#faq'
  get  'contact',     to: 'static_pages#contact'
  get  'empty_site',  to: 'static_pages#empty_site'
  get  '/login',      to: 'sessions#login'
  post '/login',      to: 'sessions#create'
  delete '/sessions', to: 'sessions#destroy'

  resources :users 
  resources :sessions
end
