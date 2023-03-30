# frozen_string_literal: true

require 'rails/generators/base'
require "rails/generators/active_record"

module Devise
  module Generators
        class Kanban7Generator < Rails::Generators::Base
            include ActiveRecord::Generators::Migration

            namespace "kanban7"
            source_root File.expand_path("../../templates/", __FILE__)

            argument :board, required: true
            argument :list, required: true
            argument :card, required: true

            def validate
                @board_model = board.to_s.classify.constantize
                unless @board_model.superclass == ApplicationRecord
                    raise ArgumentError, "board model(#{@board_model}) should be an ApplicationRecord"
                end

                @board_name = @board_model.name.downcase
                @boards_name = @board_name.pluralize

                if list == :fixed
                    @fixed_lists = true
                else
                    @list_model = list.to_s.classify.constantize
                    unless @list_model.superclass == ApplicationRecord
                        raise ArgumentError, "list model(#{@list_model}) should be an ApplicationRecord"
                    end

                    @list_name = @list_model.name.downcase
                    @lists_name = @list_name.pluralize
                end

                @card_model = card.to_s.classify.constantize
                unless @card_model.superclass == ApplicationRecord
                    raise ArgumentError, "card model(#{@card_model}) should be an ApplicationRecord"
                end

                @card_name = @card_model.name.downcase
                @cards_name = @card_name.pluralize

            end

            def scaffold
                @migration_version = "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
                unless @list_model.columns_hash.key?("position")
                    @table_name = list.tableize
                    migration_template "migrations/add_position.rb", "#{db_migrate_path}/add_position_to_#{@table_name}.rb"
                end

                unless @card_model.columns_hash.key?("position")
                    @table_name = card.tableize
                    migration_template "migrations/add_position.rb", "#{db_migrate_path}/add_position_to_#{@table_name}.rb"
                end

                puts "!!! Please run `rails db:migrate` to add :position columns to kanban-model table" if @table_name

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
