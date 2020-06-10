# frozen_string_literal: true

require "yaml"

require "bristle/setup/base_setup"
require "bristle/util/core_extensions"

using Bristle::Util::CoreExtensions

module Bristle
  module Setup
    # Rubocop setup
    class RubocopSetup < BaseSetup
      protected

      def setup_project
        rubocop = project.linters[:rubocop]
        return unless rubocop

        rubocop_config_file = (project.dir + ".rubocop.yml").subpath(base: Pathname.pwd)

        task(name: "Checking #{rubocop_config_file}") do
          content = YAML.dump(rubocop.settings)
          rubocop_config_file.update(content: content, binmode: false) ? "(changed)" : true
        end
      end
    end
  end
end
