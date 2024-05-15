Rails.application.routes.draw do
  devise_for :users

  root "kanban#index"
  post "/kanban/dnd_card", to: "kanban#dnd_card"

  resources :boards, shallow: true do
    resources :lists, shallow: true, except: [:index, :show] do
      get :actions, on: :member
      resources :cards, except: [:index]
    end
  end
end
