# frozen_string_literal: true

require 'rails_helper'

RSpec.describe List, type: :model do
    it { should belong_to(:user) }
    it { should belong_to(:board) }
    it { should have_many(:cards).dependent(:destroy) }
    
    it { should validate_presence_of(:name) }
end
