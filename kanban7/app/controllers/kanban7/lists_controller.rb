# frozen_string_literal: true

module Kanban7
    class ListsController < KanbanController
        before_action :check_fixed_list
        before_action :get_board, only: [:new, :create]
        before_action :get_list, only: [:edit, :update, :destroy]

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

            def get_board
                @board ||= @board_configs.board_model.find(params["#{@board_configs.board_model_name}_id"])
            end

            def check_fixed_list
                head :bad_request if @board_configs.fixed_lists?
            end
    end
end
