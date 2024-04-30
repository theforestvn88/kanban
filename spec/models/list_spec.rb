# frozen_string_literal: true

require 'rails_helper'

RSpec.describe List, type: :model do
    it { should belong_to(:user) }
    it { should belong_to(:board) }
    it { should have_many(:cards).dependent(:destroy) }
    
    it { should validate_presence_of(:name) }

    let!(:user) { create(:user) }
    let!(:board) { create(:board) }

    it "set position before create" do
        list1 = List.create(name: "list1", board: board, user: user)
        expect(list1.position).to eq(1)
        expect(list1.prev_position).to eq(0)

        list2 = List.create(name: "list2", board: board, user: user)
        expect(list2.position).to eq(2)
        expect(list2.prev_position).to eq(1)
    end

    it "sorted cards by position" do
        list = List.create(name: "list", board: board, user: user)
        card1 = Card.create(title: "1", list: list, board: board, user: user)
        card2 = Card.create(title: "2", list: list, board: board, user: user)
        card3 = Card.create(title: "3", list: list, board: board, user: user)

        card1.prev_position = 10
        card1.position = 11
        card1.save

        expect(list.cards).to eq([card2, card3, card1])
    end
end
