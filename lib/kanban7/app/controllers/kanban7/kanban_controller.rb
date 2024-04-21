# frozen_string_literal: true

module Kanban7
    class KanbanController < ApplicationController
        include Kanbanize
        include Flash

        before_action :set_configs

        def user_action_move?
            params["user-action"] == "move"
        end
    end
end
