require 'rails_helper'

RSpec.describe "Kanbans", type: :request do
  context "anonymous user" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

  context "signed_in user" do
    it "redirect to boards" do
      sign_in create(:user)
      get "/"
      expect(response).to redirect_to(:boards)
    end
  end
end
