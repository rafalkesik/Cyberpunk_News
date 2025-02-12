Rails.application.routes.draw do
  get '', to: redirect("/#{I18n.default_locale}"), as: :redirect_root

  scope '/:locale' do
    root 'posts#index'
    get  'guidelines',  to: 'static_pages#guidelines'
    get  'faq',         to: 'static_pages#faq'
    get  'contact',     to: 'static_pages#contact'

    delete 'post_likes',    to: 'post_likes#destroy'
    delete 'comment_likes', to: 'comment_likes#destroy'

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
    resources :comments
    resources :post_likes
    resources :comment_likes
    resources :categories, param: :slug
  end
end
