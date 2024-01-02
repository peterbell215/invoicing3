Rails.application.routes.draw do
  resources :clients

  root 'static#home'
end
