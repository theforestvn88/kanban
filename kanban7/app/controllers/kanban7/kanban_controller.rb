# frozen_string_literal: true

module Kanban7
    class KanbanController < ApplicationController
        include Kanbanize

        before_action :set_configs

        private

            def fetch_lists(*params)
                @@board_configs.fetch_lists&.call(*params)
            end
            helper_method :fetch_lists

            def fetch_cards(*params)
                @@board_configs.fetch_cards&.call(*params)
            end
            helper_method :fetch_cards
    end
end
