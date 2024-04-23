# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Card do
    it { should belong_to(:list) }

    it { should validate_presence_of(:title) }
end
