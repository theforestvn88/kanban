module ActionDispatch::Routing
    class Mapper
        def kanban(name, board: "board", list: "list", card: "card")
            scope "/kanban" do
                get "/:name/#{board}s/:#{board}_id", to: "#{name}_kanban#show", as: "#{name}_kanban", :defaults => { :name => name }
            end

            namespace "kanban7", as: "" do
                get "/:name/#{board}s/:#{board}_id/#{list}s/new", to: 'lists#new', as: "#{name}_kanban_new_#{list}", :defaults => { :name => name }
                post "/:name/#{board}s/:#{board}_id/#{list}s", to: 'lists#create', as: "#{name}_kanban_create_#{list}", :defaults => { :name => name }
                patch "/:name/#{list}s/:#{list}_id", to: 'lists#update', as: "#{name}_kanban_update_#{list}", :defaults => { :name => name }
                
                get "/:name/#{list}s/:#{list}_id/#{card}s", to: 'cards#load_more', as: "#{name}_kanban_load_#{card}s", :defaults => { :name => name }
                get "/:name/#{list}s/:#{list}_id/#{card}s/new", to: 'cards#new', as: "#{name}_kanban_new_#{card}", :defaults => { :name => name }
                post "/:name/#{list}s/:#{list}_id/#{card}s", to: 'cards#create', as: "#{name}_kanban_create_#{card}", :defaults => { :name => name }
                get "/:name/#{card}s/:#{card}_id/edit", to: 'cards#edit', as: "#{name}_kanban_edit_#{card}", :defaults => { :name => name }
                patch "/:name/#{card}s/:#{card}_id", to: 'cards#update', as: "#{name}_kanban_update_#{card}", :defaults => { :name => name }
                delete "/:name/#{card}s/:#{card}_id", to: 'cards#destroy', as: "#{name}_kanban_delete_#{card}", :defaults => { :name => name }
            end
        end
    end
end
