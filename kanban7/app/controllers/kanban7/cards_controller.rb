# frozen_string_literal: true

module Kanban7
    class CardsController < KanbanController
        before_action :get_list, only: [:new, :create, :load_more]
        before_action :get_card, only: [:edit, :update]

        def new
        end

        def create
            @card = board_configs.card_model.new(card_params)
            @card.position = card_position
        
            respond_to do |format|
              @card.save
              format.turbo_stream
            end
        end

        def edit
        end

        def update
            respond_to do |format|
                update_params = card_params
                update_params.merge!(position: card_position) unless card_params[:position].present? || card_position.nil?
                @card.update(update_params)
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

            def get_card
                @card ||= board_configs.card_model.find(params["#{board_configs.card_model_name}_id"])
            end

            def after_card
                @after_card ||= board_configs.card_model.find_by(id: params[:after_card])
            end

            def after_card_position
                after_card&.position
            end

            def card_position
                return board_configs.card_model.count if after_card_position.nil?

                list_model_id_sym = "#{board_configs.list_model_name}_id".to_sym
                next_after_card = board_configs.card_model.where(list_model_id_sym => @card.send(list_model_id_sym)).where("position > ?", after_card_position).first
                next_after_card.nil? ? after_card.position + 1 : (after_card.position + next_after_card.position) / 2.0
            end
    end
end
