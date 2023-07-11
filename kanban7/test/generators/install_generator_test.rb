# frozen_string_literal: true

require "test_helper"
require "generators/kanban7/install_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
    tests Kanban7::Generators::InstallGenerator
    destination File.expand_path("../../tmp", __FILE__)
    setup :prepare_destination

    test "assert all files are properly created" do
        run_generator
        assert_file "config/initializers/kanban7.rb"
    end
end
