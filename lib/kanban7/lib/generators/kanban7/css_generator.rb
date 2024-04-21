# frozen_string_literal: true

require 'rails/generators/base'

module Kanban7
    module Generators
        class CssGenerator < Rails::Generators::Base
            source_root File.expand_path("../../templates", __FILE__)

            def copy_css
                copy_file "assets/stylesheets/kanban.css", "app/assets/stylesheets/kanban.css"
            end
        end
    end
end