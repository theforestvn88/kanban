# frozen_string_literal: true

module Kanban7
    class ListsController < KanbanController
        before_action :get_board, only: [:new, :create]

        def new
        end

        def create
            @list = board_configs.list_model.new(list_params)
        
            respond_to do |format|
              @list.save
              format.turbo_stream
            end
        end

        def update
            @list = board_configs.list_model.find(params["#{board_configs.list_model_name}_id"])

            respond_to do |format|
              @list.update(list_params)
              format.turbo_stream
            end
        end

        private

            def list_params
                params.require(board_configs.list_model_name).permit(board_configs.list_model.columns.map(&:name))
            end

            def get_board
                @board ||= board_configs.board_model.find(params["#{board_configs.board_model_name}_id"])
            end
    end
end
