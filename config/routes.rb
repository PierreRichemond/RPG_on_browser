# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'pages#index'
  resources :fighters
  resources :fights, only: [:create, :show]
end
