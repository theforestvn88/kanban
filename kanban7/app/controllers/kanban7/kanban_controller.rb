# frozen_string_literal: true

module Kanban7
    class KanbanController < ApplicationController
        include Kanbanize
        before_action :set_configs
    end
end
