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

  def self.define_kanban(board_name, &block)
    block.call define_kanban_configs(board_name)
  end

  def self.define_kanban_configs(board_name)
    @@board_configs[board_name] = Kanban7::BoardConfigs.new(board_name)
  end

  def self.save_board_configs(board_name, board_configs)
    @@board_configs[board_name] = board_configs
  end

  def self.fetch_board_configs(board_name, &block)
    return @@board_configs[board_name.to_s] if @@board_configs.has_key?(board_name.to_s)

    block&.call define_kanban_configs(board_name)
    @@board_configs[board_name]
  end
end
