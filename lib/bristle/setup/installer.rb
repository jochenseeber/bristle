# frozen_string_literal: true

require "bristle/setup/git_setup"
require "bristle/setup/rake_setup"
require "bristle/setup/rubocop_setup"
require "bristle/setup/ruby_setup"
require "bristle/setup/visual_studio_code_setup"

module Bristle
  module Setup
    # Project installer
    class Installer
      attr_reader :project

      def initialize(project:)
        @project = project
      end

      def install
        Setup::GitSetup.new(project: project).setup
        Setup::RubySetup.new(project: project).setup
        Setup::RubocopSetup.new(project: project).setup
        Setup::RakeSetup.new(project: project).setup
        Setup::VisualStudioCodeSetup.new(project: project).setup
      end
    end
  end
end
