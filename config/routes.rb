Rails.application.routes.draw do
  root "kanban#index"
  devise_for :users
  resources :boards do
    resources :lists, expect: [:index, :show] do
      resources :cards
    end
  end
end
