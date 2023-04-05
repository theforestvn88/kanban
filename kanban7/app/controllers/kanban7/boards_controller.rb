# frozen_string_literal: true

module Kanban7
  class BoardsController < ApplicationController
    def self.kanban(name)
      yield
      
      board_configs = Kanban7.fetch_board_configs(name)
      alias_method "fetch_lists", "fetch_#{board_configs.list_model_name.pluralize}"
      alias_method "fetch_cards", "fetch_#{board_configs.card_model_name.pluralize}"
      helper_method :fetch_cards
    end
    
    before_action :set_board

    def show
    end

    private

      def board_configs
        @board_configs ||= Kanban7.fetch_board_configs(params[:name])
      end

      def set_board
        @board = board_configs.board_model.find(params[:id])
        @lists = fetch_lists(@board, params[:order] || :asc, params[:offset], params[:limit])
      end
  end
end
