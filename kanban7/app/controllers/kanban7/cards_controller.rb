# frozen_string_literal: true

module Kanban7
    class CardsController < KanbanController
        before_action :add_card_rate_limit!, only: [:new, :create]
        before_action :move_card_rate_limit!, only: [:update]
        before_action :modify_card_rate_limit!, only: [:edit, :update, :destroy]

        before_action :get_list, only: [:new, :create, :load_more]
        before_action :get_card, only: [:show, :edit, :update, :destroy]

        before_action :check_add_card_policy, only: [:new, :create]
        before_action :check_modify_card_policy, only: [:edit, :update, :destroy]
        before_action :check_move_card_policy, only: [:update]

        def show
        end

        def new
            if @board_configs.fixed_lists?
                @card = @board_configs.card_model.new(@board_configs.list_model_symbol => @list.id)
            else 
                @card = @board_configs.card_model.new(@board_configs.list_model_symbol => @list)
            end
        end

        def create
            @card = @board_configs.card_model.new(card_params)
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

        def destroy
            @card.destroy
            respond_to do |format|
                format.turbo_stream
            end
        end

        def load_more
            @cards = fetch_cards(@list, params)
            @next_offset = @cards.length == 0 || @cards.length < params[:limit].to_i ? -1 : @cards.length
        end

        private

            def card_params
                params.require(@board_configs.card_model_name).permit(@board_configs.card_model.columns.map(&:name))
            end

            def get_card
                @card ||= @board_configs.card_model.find(params["#{@board_configs.card_model_name}_id"])
            end

            def after_card
                @after_card ||= @board_configs.card_model.find_by(id: params[:after_card])
            end

            def after_card_position
                after_card&.position || params[:prev_position]
            end

            def card_position
                return @board_configs.card_model.count if after_card_position.nil?

                next_after_card = @board_configs.card_model.where(@board_configs.card_parent_id_symbol => @card.send(@board_configs.card_parent_id_symbol)).where("position > ?", after_card_position).first
                next_after_card.nil? ? after_card_position.to_i + 1 : (after_card_position.to_i + next_after_card.position) / 2.0
            end

            def check_add_card_policy
                head :bad_request unless @board_configs.can_add_card?(@list, current_user)
            end

            def check_modify_card_policy
                head :bad_request unless @board_configs.can_modify_card?(@card, current_user)
            end

            def check_move_card_policy
                head :bad_request unless @board_configs.can_move_card?(@card, current_user)
            end

            def add_card_rate_limit!
                @board_configs.add_card_rate_limit!(current_user, request.ip)
            rescue Kanban7::RateLimiter::LimitExceeded => err
                head :too_many_requests
            end

            def move_card_rate_limit!
                @board_configs.move_card_rate_limit!(current_user, request.ip)
            rescue Kanban7::RateLimiter::LimitExceeded => err
                head :too_many_requests
            end

            def modify_card_rate_limit!
                @board_configs.modify_card_rate_limit!(current_user, request.ip)
            rescue Kanban7::RateLimiter::LimitExceeded => err
                head :too_many_requests
            end
    end
end
