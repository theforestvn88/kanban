# frozen_string_literal: true

require 'rails/generators/base'
require 'rails/generators/named_base'
require "rails/generators/active_record"

module Generators
    class Kanban7Generator < Rails::Generators::Base
        include ActiveRecord::Generators::Migration
        include Rails::Generators::ResourceHelpers

        namespace "kanban7"
        source_root File.expand_path("../../templates/", __FILE__)

        argument :name, require: true
        argument :board_arg, required: true
        argument :list_arg, required: true
        argument :card_arg, required: true

        REJECT_ATTRIBUTES = %w( id position created_at updated_at )

        def validate
            @kanban_name = name
            
            board = board_arg.split(":").last
            @board_model = board.to_s.classify.constantize
            unless @board_model < ApplicationRecord
                raise ArgumentError, "board model(#{@board_model}) should be an ApplicationRecord"
            end

            @board_name = @board_model.name.downcase
            @board_id = @board_name + "_id"
            @boards_name = @board_name.pluralize


            list_type, list = list_arg.split(":")
            if list_type == "fixed-list"
                @fixed_lists = true
                @list_model = :fixed
                @list_name = list
            else
                @list_model = list.to_s.classify.constantize
                unless @list_model < ApplicationRecord
                    raise ArgumentError, "list model(#{@list_model}) should be an ApplicationRecord"
                end

                @list_name = @list_model.name.downcase
                @list_id = @list_name + "_id"
                @lists_name = @list_name.pluralize
                @list_attributes = @list_model.columns.reject { |c| 
                    REJECT_ATTRIBUTES.include?(c.name) || c.name == @board_id
                }.map { |c| 
                    Rails::Generators::GeneratedAttribute.parse("#{c.name}:#{c.type}") 
                }
            end

            card = card_arg.split(":").last
            @card_model = card.to_s.classify.constantize
            unless @card_model < ApplicationRecord
                raise ArgumentError, "card model(#{@card_model}) should be an ApplicationRecord"
            end

            @card_name = @card_model.name.downcase
            @cards_name = @card_name.pluralize
            @card_attributes = @card_model.columns.reject { |c| 
                REJECT_ATTRIBUTES.include?(c.name) || c.name == @list_id || c.name == @board_id
            }.map { |c| 
                Rails::Generators::GeneratedAttribute.parse("#{c.name}:#{c.type}") 
            }
        end

        def scaffold
            # models
            @migration_version = "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
            unless @fixed_lists || @list_model.columns_hash.key?("position")
                @table_name = list.tableize
                migration_template "migrations/add_position.rb", "#{db_migrate_path}/add_position_to_#{@table_name}.rb"
            end

            unless @card_model.columns_hash.key?("position")
                @table_name = card.tableize
                migration_template "migrations/add_position.rb", "#{db_migrate_path}/add_position_to_#{@table_name}.rb"
            end

            puts "!!! Please run `rails db:migrate` to add :position columns to the kanban-model table" if @table_name


            # views
            template "controllers/boards_controller.rb", "app/controllers/#{name}_kanban_controller.rb"
            template "views/boards/_header.html.erb", "app/views/#{name}_kanban/#{@boards_name}/_header.html.erb"
            template "views/lists/_header.html.erb", "app/views/#{name}_kanban/#{@lists_name}/_header.html.erb" unless @fixed_lists
            template "views/lists/_form.html.erb", "app/views/#{name}_kanban/#{@lists_name}/_form.html.erb" unless @fixed_lists
            template "views/cards/_card.html.erb", "app/views/#{name}_kanban/#{@cards_name}/_card.html.erb"
            template "views/cards/_detail.html.erb", "app/views/#{name}_kanban/#{@cards_name}/_#{@card_name}.html.erb"
            template "views/cards/_form.html.erb", "app/views/#{name}_kanban/#{@cards_name}/_form.html.erb"


            # routes
            kanban_route = "kanban '#{name}', board: '#{@board_name}', list: '#{@list_name}', card: '#{@card_name}'"
            route kanban_route

            
            # initializer
            insert_into_file "config/initializers/kanban7.rb", <<~RUBY
                Kanban7.define_kanban "#{name}" do |kanban|
                    kanban.board_model = "#{@board_model}"
                    kanban.list_model = "#{@list_model}"
                    kanban.card_model = "#{@card_model}"
                end
            RUBY
        end
    end
end