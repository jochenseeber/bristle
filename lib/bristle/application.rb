# frozen_string_literal: true

require "clamp"
require "bristle"

module Bristle
  # Main application class
  class Application < Clamp::Command
    option ["-v", "--verbose"], :flag, "Verbose output"

    subcommand %w[setup s], "Setup project", Bristle::Command::SetupCommand
    subcommand %w[print p], "Print project configuration", Bristle::Command::PrintCommand
  end
end
