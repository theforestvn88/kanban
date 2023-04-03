module ActionDispatch::Routing
    class Mapper
        def kanban(name, board: "board", list: "list", card: "card")
            scope "/kanban" do
                get '/b/:id/:type/:name', to: "#{name}_kanban#show", as: "#{name}_kanban", :defaults => { :name => name, :type => "#{board}" }
                post '/l/:type/:name', to: 'lists#create', as: "#{name}_kanban_create_#{list}", :defaults => { :name => name, :type => "#{list}" }
                put '/l/:id/:type/:name', to: 'lists#update', as: "#{name}_kanban_update_#{list}", :defaults => { :name => name, :type => "#{list}" }
                post '/c/:type/:name', to: 'cards#create', as: "#{name}_kanban_create_#{card}", :defaults => { :name => name, :type => "#{card}" }
                put '/c/:id/:type/:name', to: 'cards#update', as: "#{name}_kanban_update_#{card}", :defaults => { :name => name, :type => "#{card}" }
            end
        end
    end
end
