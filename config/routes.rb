Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]

  root "events#index"

  resources :events do
    resources :invitations, only: [:create]
  end

end
