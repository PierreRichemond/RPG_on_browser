# frozen_string_literal: true
Rails.application.routes.draw do
  get 'fighters/index'
  get 'fighters/show'
  get 'fighters/new'
  get 'fighters/create'
  get 'fighters/destroy'
  get 'fighters/edit'
  get 'fighters/update'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'pages#index'
  resources :fighters
  resources :fightfighters
  resources :fights
end
