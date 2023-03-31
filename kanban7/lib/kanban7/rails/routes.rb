module ActionDispatch::Routing
    class Mapper
        def kanban(board, list, card)
            namespace :kanban7 do
                get '/boards/:id', to: 'boards#show', as: 'kanban_board'
                post '/lists/', to: 'lists#create', as: 'kanban_create_list'
                put '/lists/:id', to: 'lists#update', as: 'kanban_update_list'
                post '/cards/', to: 'cards#create', as: 'kanban_create_card'
                put '/cards/:id', to: 'cards#update', as: 'kanban_update_card'
            end
        end
    end
end
