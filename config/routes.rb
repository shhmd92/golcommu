# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users do
    collection do
      get :following, :followers, :search
    end
  end

  resources :events, except: [:index], param: :url_token, shallow: true do
    resources :comments, only: [:create, :destroy]
    collection do
      get :search
    end
  end

  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :participants, only: [:create, :destroy]

  resources :users, path: '/', only: [:show, :edit, :update, :destroy], constraints: { id: /[^\/]+/ }

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
