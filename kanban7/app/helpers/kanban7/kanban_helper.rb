# frozen_string_literal: true

module Kanban7
    module KanbanHelper
        def show_board(board_name, **attributes)
            # TODO:
        end

        def position(kanban_object, index = 0)
            index < 0 ? 0 : (kanban_object&.position || kanban_object&.id || 0)
        end
    end
end
