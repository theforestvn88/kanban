module TurboStreamHelper
    module CustomActions
        def move_before(from_view_id, to_view_id)
            turbo_stream_action_tag(
                :move_before,
                from_view_id: from_view_id,
                to_view_id: to_view_id
            )
        end
    end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamHelper::CustomActions) 
