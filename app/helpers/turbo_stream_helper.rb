module TurboStreamHelper
    module CustomActions
        def move_before(move_view_id, before:)
            turbo_stream_action_tag(
                :move_before,
                move_view_id: move_view_id,
                before_view_id: before
            )
        end
    end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamHelper::CustomActions) 
