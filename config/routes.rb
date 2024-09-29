Rails.application.routes.draw do
  devise_for :users

  resources :projects, only: %i[index create update]
  root "projects#index"
end
