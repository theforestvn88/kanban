require 'rails_helper'

RSpec.describe Kanban::ListUpdateOrder, type: :service do
    let!(:board) { create(:board) }
    let!(:list1) { create(:list, board: board) }
    let!(:list2) { create(:list, board: board) }
    let!(:list3) { create(:list, board: board) }
    let!(:list4) { create(:list, board: board) }

    it "should throw error with invalid order" do
        result = Kanban::ListUpdateOrder.call(list: list1, order: 0)
        expect(result.success).to be_falsy
        expect(result.errors.first).to eq(ArgumentError.new("Invalid Order"))
    end

    it "update list order by updating position inject between 2 target lists" do
        result = Kanban::ListUpdateOrder.call(list: list1, order: 3)
        expect(result.success).to be_truthy
        expect(board.lists.map(&:id)).to eq([list2.id, list3.id, list1.id, list4.id])
    end

    it "update list order by swapping list positions" do
        result = Kanban::ListUpdateOrder.call(list: list1, order: 2)
        expect(result.success).to be_truthy
        expect(board.lists.map(&:id)).to eq([list2.id, list1.id, list3.id, list4.id])
    end

    it "update list order to the end" do
        result = Kanban::ListUpdateOrder.call(list: list1, order: 4)
        expect(result.success).to be_truthy
        expect(board.lists.map(&:id)).to eq([list2.id, list3.id, list4.id, list1.id])
    end

    it "update list order to the beginning" do
        result = Kanban::ListUpdateOrder.call(list: list3, order: 1)
        expect(result.success).to be_truthy
        expect(board.lists.map(&:id)).to eq([list3.id, list1.id, list2.id, list4.id])
    end

    it "should not change position when order is the same" do
        result = Kanban::ListUpdateOrder.call(list: list2, order: 2)
        expect(result.success).to be_truthy
        expect(board.lists.map(&:id)).to eq([list1.id, list2.id, list3.id, list4.id])
    end
end
