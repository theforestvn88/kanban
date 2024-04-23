# frozen_string_literal: true

require 'rails_helper'

RSpec.describe List do
    it { should belong_to(:board) }
    it { should have_many(:cards) }
    
    it { should validate_presence_of(:name) }
end
