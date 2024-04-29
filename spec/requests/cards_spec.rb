require 'rails_helper'
require 'requests/shared_examples/authentication_require'

RSpec.describe "/cards", type: :request do
    let!(:user) { create(:user) }
    let!(:board) { create(:board, user: user) }
    let!(:list) { create(:list, board: board, user: user) }
    let!(:card) { create(:card, list: list, user: user) }
    let(:valid_card_params) { { card: { title: "test" } } }
    let(:invalid_card_params) { { card: { title: "" } } }

    it_behaves_like "Authentication Require" do
        let(:request) { get "/lists/#{list.id}/cards/new" }
    end

    it_behaves_like "Authentication Require" do
        let(:request) { post "/lists/#{list.id}/cards.turbo_stream", params: valid_card_params }
    end

    it_behaves_like "Authentication Require" do
        let(:request) { get "/cards/#{card.id}/edit" }
    end

    it_behaves_like "Authentication Require" do
        let(:request) { put "/cards/#{card.id}.turbo_stream", params: valid_card_params }
    end

    it_behaves_like "Authentication Require" do
        let(:request) { delete "/cards/#{card.id}.turbo_stream" }
    end

    describe "crud" do
        before do
            sign_in user
        end

        it "should create new card with valid params" do
            expect {
                post "/lists/#{list.id}/cards.turbo_stream", params: valid_card_params
            }.to change(list.cards, :count).by(1)
        end

        it "should not create new card with invalid params" do
            expect {
                post "/lists/#{list.id}/cards.turbo_stream", params: invalid_card_params
            }.not_to change(list.cards, :count)
        end

        it "should update card with valid params" do
            put "/cards/#{card.id}.turbo_stream", params: { card: { title: "updated" } }
            expect(card.reload.title).to eq("updated")
        end

        it "should not update card with invalid params" do
            expect {
                put "/cards/#{card.id}.turbo_stream", params: { card: { title: "" } }
            }.not_to change(card, :title)
        end

        it "destroy card" do
            expect {
                delete "/cards/#{card.id}.turbo_stream"
            }.to change(list.cards, :count).by(-1)
        end
    end
end
