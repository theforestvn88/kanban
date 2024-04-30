require 'rails_helper'

RSpec.describe Kanban::ListDrop, type: :service do
    let!(:board) { create(:board) }
    let(:drag_list) { create(:list, board: board, prev_position: 2, position: 3) }
    let(:drop_list) { create(:list, board: board, prev_position: 1, position: 2) }

    it "update list position" do
        result = Kanban::ListDrop.call(drag_list_id: drag_list.id, drop_list_id: drop_list.id)
        expect(result.success).to be_truthy
        expect(result.drag_list.prev_position).to eq(1)
        expect(result.drag_list.position).to eq(1.5)
        expect(result.drop_list.prev_position).to eq(1.5)
        expect(result.drop_list.position).to eq(2)
    end

    it "should not allow to drag invalid list or drop invalid list" do
        result = Kanban::ListDrop.call(drag_list_id: drag_list.id, drop_list_id: -1)
        expect(result.success).to be_falsy

        result = Kanban::ListDrop.call(drag_list_id: -1, drop_list_id: drop_list.id)
        expect(result.success).to be_falsy
    end

    it "should not allow to drag and drop 2 lists on differenr board" do
        new_board = create(:board)
        new_list = create(:list, board: new_board)

        result = Kanban::ListDrop.call(drag_list_id: drag_list.id, drop_list_id: new_list.id)
        expect(result.success).to be_falsy
    end
end
