# frozen_string_literal: true

module Kanban7
    class CardsController < KanbanController
        before_action :get_list, only: [:new, :create, :load_more]

        def new
        end

        def create
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

        def load_more
            offset = params[:offset].to_i
            limit = params[:limit].to_i
            @cards = fetch_cards(@list, params[:order] || :asc, offset, limit)
            @next_offset = @cards.length == 0 || @cards.length < limit ? -1 : @cards.length
        end

        private

            def card_params
                params.require(board_configs.card_model_name).permit(board_configs.card_model.columns.map(&:name))
            end

            def get_list
                @list ||= board_configs.list_model.find(params["#{board_configs.list_model_name}_id"])
            end
    end
end
