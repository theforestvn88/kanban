require_relative "./board_configs"

module Kanban7
    class BoardConfigsSerializer < ActiveJob::Serializers::ObjectSerializer
        def serialize?(argument)
            argument.kind_of?(Kanban7::BoardConfigs)
        end

        def serialize(board_configs)
            super(board_configs.configs_clone)
        end

        def deserialize(hash)
            Kanban7::BoardConfigs.new(hash[:kanban_name]).tap { |board_configs| board_configs.merge_configs(hash) }
        end
    end
end