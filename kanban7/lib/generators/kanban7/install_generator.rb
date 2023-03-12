# frozen_string_literal: true

require 'rails/generators/base'

module Kanban7
    module Generators
        class InstallGenerator < Rails::Generators::Base
            source_root File.expand_path("../../templates", __FILE__)
            
            def copy_initializer
                template "kanban7.rb", "config/initializers/kanban7.rb"
            end
        end
    end
end

