RSpec.shared_examples "Authentication Require" do
    context "anynomous user" do
        it "returns http success" do
            request
          expect(response).to redirect_to(:new_user_session)
        end
      end
  
      context "sig_in user" do
        let(:user) { create(:user) }
  
        before do
          sign_in user
        end
  
        it "returns http success" do
          request
          expect(response).to have_http_status(:success)
        end
      end
end
