# frozen_string_literal: true

require "bristle/command/base_command"
require "bristle/setup/installer"

module Bristle
  module Command
    # Update project with current settings
    class SetupCommand < BaseCommand
      def execute
        installer = Setup::Installer.new(project: project)
        installer.install

        print_motto
      end
    end
  end
end
