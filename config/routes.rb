Rails.application.routes.draw do
  devise_for :users

  root "kanban#index"
  post "/kanban/dad_card", to: "kanban#dad_card"

  resources :boards, shallow: true do
    resources :lists, shallow: true, except: [:index, :show] do
      resources :cards, except: [:index]
    end
  end
end
