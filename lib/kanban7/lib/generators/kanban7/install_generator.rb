# frozen_string_literal: true

require 'rails/generators/base'

module Kanban7
    module Generators
        class InstallGenerator < Rails::Generators::Base
            source_root File.expand_path("../../templates", __FILE__)
            
            def copy_initializer
                template "kanban7.rb", "config/initializers/kanban7.rb"
            end

            def include_js_css
                app_layout_path = Rails.root.join("app/views/layouts/application.html.erb")

                if app_layout_path.exist?
                    say "Add kanban7 javascript include tag in application layout"
                    insert_into_file app_layout_path.to_s, "\n    <%= javascript_include_tag \"kanban7\", \"data-turbo-track\": \"reload\", \"type\": \"module\", defer: true %>", before: /\s*<\/head>/
                else
                    say "Default application.html.erb is missing!", :red
                    say "        Add <%= javascript_include_tag 'kanban7', 'data-turbo-track': 'reload', 'type': 'module', defer: true %> within the <head> tag in your custom layout."
                end


                if app_layout_path.exist?
                    say "Add kanban7 css include tag in application layout"
                    insert_into_file app_layout_path.to_s, "\n    <%= stylesheet_link_tag \"kanban7\", \"data-turbo-track\": \"reload\" %>\n", before: /\s\s\s\s\<\%\= stylesheet_link_tag \"application\"/
                else
                    say "Default application.html.erb is missing!", :red
                    say "        Add <%= stylesheet_link_tag 'kanban7', 'data-turbo-track': 'reload' %> within the <head> tag in your custom layout."
                end
            end
        end
    end
end

