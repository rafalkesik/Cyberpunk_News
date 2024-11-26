Rails.application.routes.draw do
  root 'posts#index'

  get  'guidelines',  to: 'static_pages#guidelines'
  get  'faq',         to: 'static_pages#faq'
  get  'contact',     to: 'static_pages#contact'
  get  'empty_site',  to: 'static_pages#empty_site'
  get  'in_progress', to: 'static_pages#empty_functionality'

  get  'login',      to: 'sessions#login'
  post 'login',      to: 'sessions#create'
  delete 'sessions', to: 'sessions#destroy'

  get  'new',        to: 'posts#index'

  resources :users 
  resources :sessions
  resources :posts
end
