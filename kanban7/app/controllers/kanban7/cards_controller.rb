# frozen_string_literal: true

module Kanban7
    class CardsController < KanbanController
        def create
            @list ||= board_configs.list_model.find(params["#{board_configs.list_model_name}_id"])
            @card = board_configs.card_model.new(card_params)
        
            respond_to do |format|
              @card.save
              format.turbo_stream
            end
        end

        def update
            @card = board_configs.card_model.find(params["#{board_configs.card_model_name}_id"])
            
            respond_to do |format|
              @card.update(card_params)
              format.turbo_stream
            end
        end

        private

            def card_params
                params.require(board_configs.card_model_name).permit(board_configs.card_model.columns.map(&:name))
            end
    end
end
