# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Board, type: :model do
    it { should belong_to(:user) }
    it { should have_many(:lists).dependent(:destroy) }
    it { should validate_presence_of(:name) }

    let!(:user) { create(:user) }
    let!(:board) { create(:board) }

    it "sorted cards by position" do
        list1 = List.create(name: "1", board: board, user: user)
        list2 = List.create(name: "2", board: board, user: user)
        list3 = List.create(name: "3", board: board, user: user)

        list1.prev_position = 10
        list1.position = 11
        list1.save

        expect(board.lists).to eq([list2, list3, list1])
    end
end
