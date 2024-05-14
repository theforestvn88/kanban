require 'rails_helper'

RSpec.describe "Kanbans", type: :request do
  context "anonymous user" do
    it "should redirect to sign-in" do
      get "/"
      expect(response).to redirect_to("/users/sign_in")
    end
  end

  context "signed_in user" do
    let(:user) { create(:user) }

    it "redirect to boards" do
      sign_in user
      get "/"
      expect(response).to redirect_to(:boards)
    end

    describe "sign-out" do
      it "redirect to home page" do
        sign_in user
        get "/"
        delete "/users/sign_out"
        expect(response).to redirect_to("/")
      end
    end
  end
end
