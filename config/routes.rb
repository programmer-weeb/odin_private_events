Rails.application.routes.draw do
  devise_for :users

  root "events#index"

  resources :events, only: [:index, :show, :new, :create]

end
