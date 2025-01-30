Rails.application.routes.draw do
  get '', to: redirect("/#{I18n.default_locale}"), as: :redirect_root

  scope '/:locale' do
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

    devise_for :users, controllers: { passwords: 'users/passwords',
                                      registrations: 'users/registrations' }
    resources :users
    resources :posts
    resources :liking_relations
    resources :comments
    resources :comment_liking_relations
    resources :categories, param: :slug
  end
end
