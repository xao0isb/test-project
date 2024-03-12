# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  root "posts#index"

  resources :posts, except: :destroy do
    member do
      patch :approve
      patch :decline
    end
  end

  resources :drafts, only: %i[create destroy] do
    member do
      post :submit
    end
  end

  namespace :my do
    resource :posts, only: :show
    resource :drafts, only: :show
  end

  resources :admins, only: %i[new create]

  namespace :reports do
    post :excel
  end

  namespace :download do
    post :file
  end

  match "/404", to: "errors#not_found", via: :all
end
# rubocop:enable Metrics/BlockLength
