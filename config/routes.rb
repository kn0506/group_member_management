Rails.application.routes.draw do
  root 'groups#index'
  resources :members
  resources :groups do
    patch :random_role
  end
  resources :group_members, only: %i[create]
  resource :group_members, only: %i[destroy]
end