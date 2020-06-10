# frozen_string_literal: true

QED.configure "coverage" do
  require "simplecov"

  SimpleCov.configure do
    command_name "Demos"
  end

  require File.expand_path("../test/simplecov_config.rb", __dir__)
end
