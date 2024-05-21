module Kanban
    class ListUpdateOrder < ::BaseService
        def initialize(list:, order:)
            @list = list
            @order = order
        end

        Result = Struct.new(:success, :list, :after_list, :before_list, :errors)

        def call
            if @order <= 0
                return Result.new(success: false, errors: [ArgumentError.new("Invalid Order")])
            end

            prev_list, next_list = List.find_by_sql ['
                SELECT *
                FROM (
                    SELECT *,
                        ROW_NUMBER() OVER (
                            ORDER BY position
                        ) AS row_num
                    FROM lists
                    WHERE board_id = ?
                ) t
                WHERE row_num = ? OR row_num = ?
                ORDER BY row_num
            ', @list.board_id, @order, @order + 1]
            
            # same order with next_list
            # dont change 
            if @list.id == prev_list.id
                return Result.new(success: true, list: @list, after_list: nil, before_list: nil)
            end

            update_needed_lists = []
            after_list = nil
            before_list = nil

            if @order == 1 # at the beginning
                @list.position = prev_list.position/2.0
                prev_list.prev_position = @list.position
                update_needed_lists = [@list, prev_list]
                after_list = prev_list
            elsif next_list.nil? # at the end
                @list.position = prev_list.position + 1
                @list.prev_position = prev_list.position
                update_needed_lists = [@list]
                before_list = prev_list
            elsif @list.id == next_list.id
                # swap prev <-> next
                pos = prev_list.position
                prev_pos = prev_list.prev_position
                prev_list.position = next_list.position
                prev_list.prev_position = next_list.prev_position
                next_list.position = pos
                next_list.prev_position = prev_pos

                update_needed_lists = [prev_list, next_list]
                after_list = prev_list
            else
                # inject into between prev and next
                @list.position = (prev_list.position + next_list.position) / 2.0
                prev_list.prev_position = @list.prev_position
                @list.prev_position = prev_list.position
                next_list.prev_position = @list.position

                update_needed_lists = [@list, prev_list, next_list]
                after_list = next_list
                before_list = prev_list
            end

            result = nil
            ActiveRecord::Base.transaction do
                if update_needed_lists.map(&:save!)
                    result = Result.new(success: true, list: @list, after_list: after_list, before_list: before_list)
                end
            end

            result
        rescue => e
            Result.new(success: false, errors: [e])
        end
    end
end
