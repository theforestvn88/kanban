# frozen_string_literal: true

module Kanban7
    class ListsController < KanbanController
        before_action :set_board

        def create
            @list = board_configs.list_model.new(list_params)
        
            respond_to do |format|
              if @list.save
                format.json { render :show, status: :created, location: @list }
              else
                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @list.errors, status: :unprocessable_entity }
              end

              format.turbo_stream
            end
        end

        def update
        end

        private

            def list_params
                params.require(board_configs.list_model_name).permit(board_configs.list_model.columns.map(&:name))
            end

            def set_board
                @board ||= board_configs.board_model.find(params["#{board_configs.board_model_name}_id"])
            end
    end
end
