require 'kanban7/rails/routes'
require 'kanban7/fixed_list'
require 'kanban7/policy'
require 'kanban7/rate_limiter'
require 'kanban7/fetcher'
require 'kanban7/board_configs'
require 'kanban7/board_configs_serializer'

module Kanban7
  class Engine < ::Rails::Engine
    isolate_namespace Kanban7

    config.autoload_once_paths = %W( #{root}/app/helpers )

    initializer "kanban7.assets" do
        if Rails.application.config.respond_to?(:assets)
          Rails.application.config.assets.precompile += %w( kanban7.js kanban7.css )
        end
    end
    
    initializer "kanban7.helpers" do
        ActiveSupport.on_load(:action_controller_base) do
          helper Kanban7::Engine.helpers
        end

        Rails.application.config.active_job.custom_serializers << Kanban7::BoardConfigsSerializer
    end
  end
end
