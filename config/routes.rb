Rails.application.routes.draw do
  root "kanban#index"
  devise_for :users
  resources :boards, shallow: true do
    resources :lists, shallow: true, except: [:index, :show] do
      resources :cards, except: [:index]
    end
  end
end
