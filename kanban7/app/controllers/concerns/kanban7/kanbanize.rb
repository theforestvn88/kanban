# frozen_string_literal: true

module Kanban7
    module Kanbanize
        extend ActiveSupport::Concern

        class_methods do
            def kanban(name)
                @@board_configs = Kanban7.fetch_board_configs(name)
                yield @@board_configs
            end
        end

        included do
            def set_configs
                @board_configs = Kanban7.fetch_board_configs(params[:name])
            end

            def get_board
                @board ||= @board_configs.board_model.find(params["#{@board_configs.board_model_name}_id"])
            end

            def get_list
                if @board_configs.fixed_lists?
                    @list ||= @board_configs.find_fixed_list(params[@board_configs.list_model_id_symbol])
                else
                    @list ||= @board_configs.list_model.find(params[@board_configs.list_model_id_symbol])
                end
            end

            def get_card
                @card ||= @board_configs.card_model.find(params["#{@board_configs.card_model_name}_id"])
            end
        end
    end
end
