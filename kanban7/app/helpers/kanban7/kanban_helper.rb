# frozen_string_literal: true

module Kanban7
    module KanbanHelper
        def show_board(board_name, board, **attributes)
            render template: "kanban7/boards/show", locals: {board_name: board_name, board: board}.merge(attributes)
        end
    end
end
