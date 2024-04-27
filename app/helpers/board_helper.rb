module BoardHelper
    def main_frame_tag_id_for(user)
        "user-#{user.id}-main"
    end

    def boards_grid_view_id_for(user)
        "user-#{user.id}-boards-grid"
    end
end
