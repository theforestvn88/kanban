# frozen_string_literal: true

require 'rails'
require "kanban7/version"
require "kanban7/engine"

module Kanban7
  mattr_reader :configs
  @@configs = {}

  def self.setup
    yield self
  end

  mattr_reader :board_configs
  @@board_configs = {}

  def self.define_board(board_name, configs = {})
    @@board_configs[board_name] = Kanban7::BoardConfigs.new(board_name, configs)
    yield @@board_configs[board_name] if block_given?
  end

  def self.fetch_board_configs(board_name)
    return @@board_configs[board_name] if @@board_configs.has_key?(board_name)

    define_board(board_name) do |board_configs|
      yield board_configs
    end

    @@board_configs[board_name]
  end
end
