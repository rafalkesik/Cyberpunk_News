Rails.application.routes.draw do
  get 'static_pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "static_pages#home"
  get 'guidelines',  to: 'static_pages#guidelines'
  get 'faq',         to: 'static_pages#faq'
  get 'contact',     to: 'static_pages#contact'
  get 'empty_site', to: 'static_pages#empty_site'
end
