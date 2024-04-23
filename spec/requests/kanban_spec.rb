require 'rails_helper'
require 'requests/shared_examples/authentication_require'

RSpec.describe "Kanbans", type: :request do
  it_behaves_like "Authentication Require" do
    let(:request) { get "/" }
  end
end
