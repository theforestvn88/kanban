# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Card, type: :model do
    it { should belong_to(:user) }
    it { should belong_to(:board) }
    it { should belong_to(:list) }

    it { should validate_presence_of(:title) }

    let!(:user) { create(:user) }
    let!(:board) { create(:board) }
    let!(:list) { create(:list, board: board) }

    it "set position before create" do
        card1 = Card.create(title: "card1", list: list, board: board, user: user)
        expect(card1.position).to eq(1)
        expect(card1.prev_position).to eq(0)

        card2 = Card.create(title: "card2", list: list, board: board, user: user)
        expect(card2.position).to eq(2)
        expect(card2.prev_position).to eq(1)
    end
end
