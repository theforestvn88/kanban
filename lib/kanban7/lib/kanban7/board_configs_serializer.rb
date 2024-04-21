require_relative "./board_configs"

module Kanban7
    class BoardConfigsSerializer < ActiveJob::Serializers::ObjectSerializer
        def serialize?(argument)
            argument.kind_of?(Kanban7::BoardConfigs)
        end

        def serialize(board_configs)
            super(board_configs.configs_simplify)
        end

        def deserialize(hash)
            Kanban7::BoardConfigs.new(hash[:kanban_name], hash)
        end
    end
end