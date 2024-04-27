require 'rails_helper'
require 'requests/shared_examples/authentication_require'

RSpec.describe "Lists", type: :request do
    let!(:user) { create(:user) }
    let!(:board) { create(:board, user: user) }
    let!(:list) { create(:list, board: board, user: user) }
    let(:valid_list_params) { { list: { name: "test" } } }
    let(:invalid_list_params) { { list: { name: "" } } }

    it_behaves_like "Authentication Require" do
        let(:request) { get "/boards/#{board.id}/lists/new" }
    end

    it_behaves_like "Authentication Require" do
        let(:request) { post "/boards/#{board.id}/lists.turbo_stream", params: valid_list_params }
    end

    it_behaves_like "Authentication Require" do
        let(:request) { get "/boards/#{board.id}/lists/#{list.id}/edit" }
    end

    it_behaves_like "Authentication Require" do
        let(:request) { put "/boards/#{board.id}/lists/#{list.id}.turbo_stream", params: valid_list_params }
    end

    it_behaves_like "Authentication Require" do
        let(:request) { delete "/boards/#{board.id}/lists/#{list.id}.turbo_stream" }
    end

    describe "crud" do
        before do
            sign_in user
        end

        it "should create new list with valid params" do
            expect {
                post "/boards/#{board.id}/lists.turbo_stream", params: valid_list_params
            }.to change(board.lists, :count).by(1)
        end

        it "should not create new list with invalid params" do
            expect {
                post "/boards/#{board.id}/lists.turbo_stream", params: invalid_list_params
            }.not_to change(board.lists, :count)
        end

        it "should update list with valid params" do
            put "/boards/#{board.id}/lists/#{list.id}.turbo_stream", params: { list: { name: "updated" } }
            expect(list.reload.name).to eq("updated")
        end

        it "should not update list with invalid params" do
            expect {
                put "/boards/#{board.id}/lists/#{list.id}.turbo_stream", params: { list: { name: "" } }
            }.not_to change(list, :name)
        end

        it "destroy list" do
            expect {
                delete "/boards/#{board.id}/lists/#{list.id}.turbo_stream"
            }.to change(board.lists, :count).by(-1)
        end
    end
end
