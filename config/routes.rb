Rails.application.routes.draw do
  get '', to: redirect("/#{I18n.default_locale}"), as: :redirect_root

  scope '/:locale' do
    root 'posts#index'
    get  'guidelines',  to: 'static_pages#guidelines'
    get  'faq',         to: 'static_pages#faq'
    get  'contact',     to: 'static_pages#contact'
    get  'empty_site',  to: 'static_pages#empty_site'
    get  'in_progress', to: 'static_pages#empty_functionality'

    delete 'liking_relations',         to: 'liking_relations#destroy'
    delete 'comment_liking_relations', to: 'comment_liking_relations#destroy'

    devise_scope :user do
      get    'login',  to: 'users/sessions#new'
      post   'login',  to: 'users/sessions#create'
      delete 'logout', to: 'users/sessions#destroy'
    end

    devise_for :users,
               path: '',
               path_names: { sign_in: 'login', sign_out: 'logout' },
               controllers: { passwords: 'users/passwords',
                              registrations: 'users/registrations',
                              sessions: 'users/sessions' }
    resources :users
    resources :posts
    resources :liking_relations
    resources :comments
    resources :comment_liking_relations
    resources :categories, param: :slug
  end
end
