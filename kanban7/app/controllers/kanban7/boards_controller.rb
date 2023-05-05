# frozen_string_literal: true

module Kanban7
  class BoardsController < KanbanController
    before_action :set_board

    def show
    end

    private

      def set_board
        @board = @board_configs.board_model.find(params["#{@board_configs.board_model_name}_id"])
        @lists = fetch_lists(@board, params)
      end
  end
end
