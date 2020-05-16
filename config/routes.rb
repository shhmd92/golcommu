# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users, param: :url_token do
    collection do
      get :search
    end
    member do
      get :following, :followers
    end
  end

  resources :events, param: :url_token, shallow: true do
    resources :comments, only: [:create, :destroy]
    collection do
      get :search, :autocomplete_search, :golf_course_info
    end
  end

  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :participants, only: [:create, :destroy]
  resources :notifications, only: :index

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
