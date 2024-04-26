require 'rails_helper'
require 'requests/shared_examples/authentication_require'

RSpec.describe "Boards", type: :request do
  it_behaves_like "Authentication Require" do
    let(:request) { get "/boards" }
  end

  it_behaves_like "Authentication Require" do
    let(:board) { create(:board) }
    let(:request) { get "/boards/#{board.id}" }
  end

  it_behaves_like "Authentication Require" do
    let(:request) { get "/boards/new" }
  end

  let(:user) { create(:user) }
  let(:valid_board_params) { { board: { name: "test" } } }
  let(:invalid_board_params) { { board: { name: "" } } }

  it_behaves_like "Authentication Require" do
    let(:request) { post "/boards.turbo_stream", params: valid_board_params }
  end

  describe "crud" do
    before do
      sign_in user
    end

    it "create new board with valid params" do
      expect {
        post "/boards.turbo_stream", params: valid_board_params
      }.to change(user.boards, :count).by(1)
    end

    it "do not create new board with invalid params" do
      expect {
        post "/boards.turbo_stream", params: invalid_board_params
      }.not_to change(user.boards, :count)
    end

    it "edit board with valid params" do
      edited_board = create(:board, name: "???")

      put "/boards/#{edited_board.id}.turbo_stream", params: valid_board_params
      expect(edited_board.reload.name).to eq("test")
    end

    it "edit board with invalid params" do
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
