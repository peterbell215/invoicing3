Rails.application.routes.draw do
  # devise routes
  devise_for :users, skip: [ :sessions, :passwords, :registrations ]
  as :user do
    get 'login', to: 'users/sessions#new', as: :new_user_session
    post 'login', to: 'users/sessions#create', as: :user_session
    match 'logout', to: 'users/sessions#destroy', as: :destroy_user_session, via: Devise.mappings[:user].sign_out_via
  end

  resources :clients do
    resources :prices
  end

  resources :meetings

  root 'static#home'
end
