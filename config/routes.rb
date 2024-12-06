Rails.application.routes.draw do
  resources :comment_liking_relations
  root 'posts#index'

  get  'guidelines',  to: 'static_pages#guidelines'
  get  'faq',         to: 'static_pages#faq'
  get  'contact',     to: 'static_pages#contact'
  get  'empty_site',  to: 'static_pages#empty_site'
  get  'in_progress', to: 'static_pages#empty_functionality'

  get   'login',      to: 'sessions#login'
  post  'login',      to: 'sessions#create'
  delete 'sessions',  to: 'sessions#destroy'

  get 'new',          to: 'posts#index'

  delete 'liking_relations',         to: 'liking_relations#destroy'
  delete 'comment_liking_relations', to: 'comment_liking_relations#destroy'

  resources :users
  resources :sessions
  resources :posts
  resources :liking_relations
  resources :comments
  resources :comment_liking_relations
end
