require 'rails_helper'

RSpec.describe BoardHelper, type: :helper do
    let(:current_user) { create(:user) }

    it "user boards turbo frame tag id" do
        expect(helper.main_frame_tag_id_for(current_user)).to eq("user-#{current_user.id}-main")
    end

    it "user boards grid view id" do
        expect(helper.boards_grid_view_id_for(current_user)).to eq("user-#{current_user.id}-boards-grid")
    end
end
