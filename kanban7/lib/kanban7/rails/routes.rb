module ActionDispatch::Routing
    class Mapper
        def kanban(name, board: "board", list: "list", card: "card")
            scope "/kanban" do
                get "/:name/#{board}s/:#{board}_id", to: "#{name}_kanban#show", as: "#{name}_kanban", :defaults => { :name => name }
            end

            namespace "kanban7", as: "" do
                post "/:name/#{board}s/:#{board}_id/#{list}s", to: 'lists#create', as: "#{name}_kanban_create_#{list}", :defaults => { :name => name }
                patch "/:name/#{list}s/:#{list}_id", to: 'lists#update', as: "#{name}_kanban_update_#{list}", :defaults => { :name => name }
                post "/:name/#{list}s/:#{list}_id/#{card}s", to: 'cards#create', as: "#{name}_kanban_create_#{card}", :defaults => { :name => name }
                patch "/:name/#{card}s/:#{card}_id", to: 'cards#update', as: "#{name}_kanban_update_#{card}", :defaults => { :name => name }
            end
        end
    end
end
