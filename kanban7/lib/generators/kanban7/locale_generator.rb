# frozen_string_literal: true

require 'rails/generators/base'

module Kanban7
    module Generators
        class LocaleGenerator < Rails::Generators::Base
            source_root File.expand_path("../../templates", __FILE__)

            argument :locale, require: true

            def copy_locale
                @locale = locale
                template "config/locale.yml", "config/locales/kanban7.#{locale}.yml"
            end
        end
    end
end
