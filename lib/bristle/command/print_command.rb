# frozen_string_literal: true

require "json"

using Bristle::Util::CoreExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Command
    # Update project with current settings
    class PrintCommand < BaseCommand
      def execute
        puts JSON.pretty_generate(project.dsl_json_value)
      end
    end
  end
end
