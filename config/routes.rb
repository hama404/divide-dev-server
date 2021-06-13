Rails.application.routes.draw do
  root 'api/v1/sessions#whoami'
  get '/whoami', to: 'api/v1/sessions#whoami'

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
