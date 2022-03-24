Rails.application.routes.draw do
  root 'groups#index'
  
  resources :members, only: [:new, :index, :edit, :update, :create, :show, :destroy ]

  resources :groups do
    patch 'join' => 'groups#join'
    delete 'leave' => 'groups#leave'
    post 'random_role' => 'groups#random_role'

  resources :group_members, only: [:new, :index,]

  end
end
