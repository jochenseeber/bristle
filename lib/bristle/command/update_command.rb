# frozen_string_literal: true

require "bristle/command/base_command"

module Bristle
  module Command
    # Update project with current settings
    class UpdateCommand < BaseCommand
      def execute
        puts "==> Updated: #{project.inspect}"
      end
    end
  end
end
