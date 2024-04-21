# frozen_string_literal: true

module Kanban7
    module KanbanHelper
        def show_kanban(kanban_name, board, **attributes)
            board_config = Kanban7.fetch_board_configs(kanban_name)
            turbo_frame_tag(board_config.kanban_frame, 
                src: send("#{kanban_name}_kanban_path", "#{board_config.board_model_name}_id".to_sym => board.id, offset: attributes[:offset] || 0, limit: attributes[:list_page] || 15), 
                loading: :lazy) do
                render partial: "kanban7/lists/skeleton", locals: { board: board }
            end
        end

        def position(kanban_object, index = 0)
            index < 0 ? 0 : (kanban_object&.position || kanban_object&.id || 0)
        end
    end
end
