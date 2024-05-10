module Kanban    
    module DragAndDrop
        def validate_same_board!(drag_object, drop_object)
            if drag_object.board_id != drop_object.board_id
                raise ArgumentError
            end
        end

        def validate_available!(*dnd_objects)
            # TODO
        end

        def validate_user_policy
            # TODO
        end
        
        def validate!(drag_object, drop_object)
            validate_user_policy
            validate_same_board!(drag_object, drop_object)
            validate_available!(drag_object, drop_object)
        end

        def update_position(drag_object, drop_object)
            drag_object.position = (drop_object.position + drop_object.prev_position)/2
            drag_object.prev_position = drop_object.prev_position
            drop_object.prev_position = drag_object.position
        end
    end
end
