Rails.application.routes.draw do
  get 'comments/create'
  devise_for :users

  resources :projects, only: %i[index new create update show] do
    resources :comments, only: [:create]
  end
  
  root "projects#index"
end
