# frozen_string_literal: true

module Kanban7
    class ListsController < KanbanController
        before_action :add_list_rate_limit!, only: [:new, :create]
        before_action :move_list_rate_limit!, only: [:update]
        before_action :modify_list_rate_limit!, only: [:edit, :update, :destroy]

        before_action :check_fixed_list
        before_action :get_board
        before_action :get_list, only: [:edit, :update, :destroy]

        before_action :check_add_list_policy, only: [:new, :create]
        before_action :check_modify_list_policy, only: [:edit, :update, :destroy]
        before_action :check_move_list_policy, only: [:update]

        def new
        end

        def create
            @list = @board_configs.list_model.new(list_params)
        
            respond_to do |format|
              @list.save
              format.turbo_stream
            end
        end

        def edit
        end

        def update
            respond_to do |format|
              @list.update(list_params)
              format.turbo_stream
            end
        end

        def destroy
            ActiveRecord::Base.transaction do
                @board_configs.card_model.where("#{@board_configs.list_model_name}_id".to_sym => @list.id).all.destroy_all
                @list.destroy
                respond_to do |format|
                    format.turbo_stream
                end
            rescue => exception
                # TODO:
            end
        end

        private

            def list_params
                params.require(@board_configs.list_model_name).permit(@board_configs.list_model.columns.map(&:name))
            end

            def check_fixed_list
                head :bad_request if @board_configs.fixed_lists?
            end

            def check_add_list_policy
                flash_error ::I18n.t('kanban7.error.not_allow_add_list'), status: :bad_request unless @board_configs.can_add_list?(@board, current_user)
            end

            def check_modify_list_policy
                return if user_action_move?
                flash_error ::I18n.t('kanban7.error.not_allow_modify_list'), status: :bad_request unless @board_configs.can_modify_list?(@list, current_user)
            end

            def check_move_list_policy
                return unless user_action_move?
                flash_error ::I18n.t('kanban7.error.not_allow_move_list'), status: :bad_request unless @board_configs.can_move_list?(@list, current_user)
            end

            def add_list_rate_limit!
                @board_configs.add_list_rate_limit!(current_user, request.ip)
            rescue Kanban7::RateLimiter::LimitExceeded => err
                flash_error ::I18n.t('kanban7.error.rate_limit_exceeded'), status: :too_many_requests
            end

            def move_list_rate_limit!
                return unless user_action_move?
                @board_configs.move_list_rate_limit!(current_user, request.ip)
            rescue Kanban7::RateLimiter::LimitExceeded => err
                flash_error ::I18n.t('kanban7.error.rate_limit_exceeded'), status: :too_many_requests
            end

            def modify_list_rate_limit!
                return if user_action_move?
                @board_configs.modify_list_rate_limit!(current_user, request.ip)
            rescue Kanban7::RateLimiter::LimitExceeded => err
                flash_error ::I18n.t('kanban7.error.rate_limit_exceeded'), status: :too_many_requests
            end
    end
end
