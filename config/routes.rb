Rails.application.routes.draw do
  get '', to: redirect("/#{I18n.default_locale}"), as: :redirect_root

  scope '/:locale' do
    root 'posts#index'
    get  'guidelines',  to: 'static_pages#guidelines'
    get  'faq',         to: 'static_pages#faq'
    get  'contact',     to: 'static_pages#contact'

    delete 'liking_relations',         to: 'liking_relations#destroy'
    delete 'comment_liking_relations', to: 'comment_liking_relations#destroy'

    devise_scope :user do
      get    'users/sign_in',  to: 'users/sessions#new', as: :login
      delete 'users/sign_out', to: 'users/sessions#destroy', as: :logout
    end

    devise_for :users,
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
