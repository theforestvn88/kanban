Rails.application.routes.draw do
  root "kanban#index"
  devise_for :users
  resources :boards
end
