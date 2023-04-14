# frozen_string_literal: true

module Kanban7
    class KanbanController < ApplicationController
        class_attribute :board_configs, instance_writer: false

        def self.kanban(name)
            yield
            KanbanController.board_configs ||= Kanban7.fetch_board_configs(name)
        end

        helper_method :fetch_lists
        helper_method :fetch_cards

        before_action :set_configs


        private

            def set_configs
                @board_configs = board_configs
            end

            def fetch_lists(*params)
                "#{board_configs.kanban_name}_kanban_controller".classify.constantize.try("fetch_#{board_configs.list_model_name.pluralize}", *params)
            end

            def fetch_cards(*params)
                "#{board_configs.kanban_name}_kanban_controller".classify.constantize.try("fetch_#{board_configs.card_model_name.pluralize}", *params)
            end
    end
end
