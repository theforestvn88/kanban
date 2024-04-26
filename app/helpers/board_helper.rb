module BoardHelper
    def board_frame_tag_id_for(user)
        "user-#{user.id}-board"
    end

    def boards_grid_view_id_for(user)
        "user-#{user.id}-boards-grid"
    end
end
