Rails.application.routes.draw do
  devise_for :users

  resources :projects, only: %i[index new create update show]
  root "projects#index"
end
