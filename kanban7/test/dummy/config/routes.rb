Rails.application.routes.draw do
  mount Kanban7::Engine => "/kanban7"

  root "kanban#index"
end
