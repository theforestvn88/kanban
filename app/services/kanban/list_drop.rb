module Kanban    
    class ListDrop
        include DragAndDrop

        def self.call(...)
            new(...).call
        end

        def initialize(drag_list_id:, drop_list_id:)
            @drag_list_id = drag_list_id
            @drop_list_id = drop_list_id
        end

        Result = Struct.new(:success, :drag_list, :drop_list, :error)

        def call
            result = nil
            ActiveRecord::Base.transaction do
                @drag_list = List.find(@drag_list_id)
                @drop_list = List.find(@drop_list_id)
                
                validate!(@drag_list, @drop_list)

                update_position(@drag_list, @drop_list)
                @drag_list.save!
                @drop_list.save!

                result = Result.new(success: true, drag_list: @drag_list, drop_list: @drop_list)
            end

            result
        rescue => e
            Result.new(success: false, error: e)
        end

        private

            attr_reader :drag_list_id, :drop_list_id
    end
end
