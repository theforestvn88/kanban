# frozen_string_literal: true

module Kanban7
    class FixedList
        def self.from(list, save_as:)
            list.map.with_index { |x, i| FixedList.new(i, x, i, save_as: save_as) }
        end

        attr_accessor :to_key
        attr_reader :id, :index, :name, :position

        def initialize(index, name, position, save_as:)
            @index = index
            @name = name
            @position = position
            @id = self.send(save_as)

            @to_key = [@id] # support dom_id
        end

        def model_name
            OpenStruct.new param_key: @name # support dom_id
        end
    end
end
