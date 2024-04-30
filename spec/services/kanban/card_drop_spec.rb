require 'rails_helper'

RSpec.describe Kanban::CardDrop, type: :service do
    let!(:board) { create(:board) }
    let!(:list) { create(:list, board: board) }
    let(:drag_card) { create(:card, list: list, board: board, prev_position: 2, position: 3) }
    let(:drop_card) { create(:card, list: list, board: board, prev_position: 1, position: 2) }

    it "update card position" do
        result = Kanban::CardDrop.call(drag_card_id: drag_card.id, drop_card_id: drop_card.id)
        expect(result.success).to be_truthy
        expect(result.drag_card.prev_position).to eq(1)
        expect(result.drag_card.position).to eq(1.5)
        expect(result.drop_card.prev_position).to eq(1.5)
        expect(result.drop_card.position).to eq(2)
    end

    it "update drag-card list-id" do
        result = Kanban::CardDrop.call(drag_card_id: drag_card.id, drop_card_id: drop_card.id)
        expect(result.success).to be_truthy
        expect(result.drag_card.list_id).to eq(drop_card.list_id)
    end

    it "should not allow to drag invalid card or drop invalid card" do
        result = Kanban::CardDrop.call(drag_card_id: drag_card.id, drop_card_id: -1)
        expect(result.success).to be_falsy

        result = Kanban::CardDrop.call(drag_card_id: -1, drop_card_id: drop_card.id)
        expect(result.success).to be_falsy
    end

    it "should not allow to drag_and_drop 2 cards belong to 2 different boards" do
        new_board = create(:board)
        new_list = create(:list, board: new_board)
        new_card = create(:card, board: new_board, list: new_list)

        result = Kanban::CardDrop.call(drag_card_id: drag_card.id, drop_card_id: new_card.id)
        expect(result.success).to be_falsy

        result = Kanban::CardDrop.call(drag_card_id: new_card.id, drop_card_id: drop_card.id)
        expect(result.success).to be_falsy
    end
end
