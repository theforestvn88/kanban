# frozen_string_literal: true

module Kanban7
    class CardsController < KanbanController
        before_action :set_list
        
        def create
            @card = board_configs.card_model.new(card_params)
        
            respond_to do |format|
              if @card.save
                format.json { render :show, status: :created, location: @card }
              else
                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @card.errors, status: :unprocessable_entity }
              end

              format.turbo_stream
            end
        end

        def update
        end

        private

            def card_params
                params.require(board_configs.card_model_name).permit(board_configs.card_model.columns.map(&:name))
            end

            def set_list
                @list ||= board_configs.list_model.find(params["#{board_configs.list_model_name}_id"])
            end
    end
end
