# frozen_string_literal: true

require 'rails/generators/base'

module Devise
  module Generators
        class Kanban7Generator < Rails::Generators::Base
            # include Rails::Generators::ResourceHelpers
            namespace "kanban7"
            source_root File.expand_path("../../templates/", __FILE__)

            argument :board, required: true
            argument :list, required: true
            argument :card, required: true

            def create_controllers
                @board_model = board.to_s.classify.constantize
                @board_name = @board_model.name.downcase
                @boards_name = @board_name.pluralize

                if list == :fixed
                    @fixed_lists = true
                else
                    @list_model = list.to_s.classify.constantize
                    @list_name = @list_model.name.downcase
                    @lists_name = @list_name.pluralize
                end

                @card_model = card.to_s.classify.constantize
                @card_name = @card_model.name.downcase
                @cards_name = @card_name.pluralize

                template "controllers/boards_controller.rb", "app/controllers/#{@board_name}_kanban_controller.rb"
                template "views/boards/_header.html.erb", "app/views/#{@board_name}_kanban/boards/_header.html.erb"
                template "views/lists/_header.html.erb", "app/views/#{@board_name}_kanban/lists/_header.html.erb"
                template "views/lists/_form.html.erb", "app/views/#{@board_name}_kanban/lists/_form.html.erb"
                template "views/cards/_item.html.erb", "app/views/#{@board_name}_kanban/cards/_item.html.erb"
                template "views/cards/_form.html.erb", "app/views/#{@board_name}_kanban/cards/_form.html.erb"
            end
        end
    end
end
