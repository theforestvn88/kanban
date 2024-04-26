require 'rails_helper'

RSpec.describe BoardHelper do
    let(:current_user) { create(:user) }

    it "user boards turbo frame tag id" do
        expect(helper.board_frame_tag_id_for(current_user)).to eq("user-#{current_user.id}-board")
    end

    it "user boards grid view id" do
        expect(helper.boards_grid_view_id_for(current_user)).to eq("user-#{current_user.id}-boards-grid")
    end
end
