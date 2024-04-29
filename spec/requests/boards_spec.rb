require 'rails_helper'
require 'requests/shared_examples/authentication_require'

RSpec.describe "/boards", type: :request do
  let(:board) { create(:board) }
  let(:user) { create(:user) }
  let(:valid_board_params) { { board: { name: "test" } } }
  let(:invalid_board_params) { { board: { name: "" } } }
  
  it_behaves_like "Authentication Require" do
    let(:request) { get "/boards" }
  end

  it_behaves_like "Authentication Require" do
    let(:request) { get "/boards/new" }
  end
  
  it_behaves_like "Authentication Require" do
    let(:request) { post "/boards.turbo_stream", params: valid_board_params }
  end

  it_behaves_like "Authentication Require" do
    let(:request) { get "/boards/#{board.id}" }
  end

  it_behaves_like "Authentication Require" do
    let(:request) { get "/boards/#{board.id}/edit" }
  end

  it_behaves_like "Authentication Require" do
    let(:request) { put "/boards/#{board.id}.turbo_stream", params: valid_board_params }
  end

  it_behaves_like "Authentication Require" do
    let(:request) { delete "/boards/#{board.id}.turbo_stream" }
  end

  describe "crud" do
    before do
      sign_in user
    end

    it "should create new board with valid params" do
      expect {
        post "/boards.turbo_stream", params: valid_board_params
      }.to change(user.boards, :count).by(1)
    end

    it "should not create new board with invalid params" do
      expect {
        post "/boards.turbo_stream", params: invalid_board_params
      }.not_to change(user.boards, :count)
    end

    it "should update board with valid params" do
      edited_board = create(:board, name: "???")

      put "/boards/#{edited_board.id}.turbo_stream", params: valid_board_params
      expect(edited_board.reload.name).to eq("test")
    end

    it "should not update board with invalid params" do
      edited_board = create(:board, name: "???")

      put "/boards/#{edited_board.id}.turbo_stream", params: invalid_board_params
      expect(edited_board.reload.name).to eq("???")
    end

    it "destroy board" do
      deleted_board = create(:board, user: user)
      expect {
        delete "/boards/#{deleted_board.id}.turbo_stream"
      }.to change(user.boards, :count).by(-1)
    end
  end
end
