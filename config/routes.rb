# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users do
    collection do
      get :following, :followers
    end
  end

  resources :relationships,       only: [:create, :destroy]

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
