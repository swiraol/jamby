Rails.application.routes.draw do
  resources :group_sessions do
    get :book, on: :member
  end

  get 'signin' => 'signins#new'
  delete 'logout' => 'signins#destroy', as: :signout
  get 'signup' => 'signups#new'

  resources :signups, only: :create
  resources :signins, only: :create

  root 'group_sessions#index'
end
