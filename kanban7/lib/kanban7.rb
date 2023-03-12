# frozen_string_literal: true

require 'rails'
require "kanban7/version"
require "kanban7/engine"

module Kanban7
  def self.setup
    yield self
  end
end
