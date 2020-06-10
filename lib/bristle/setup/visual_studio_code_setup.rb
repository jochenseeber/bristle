# frozen_string_literal: true

require "yaml"

require "bristle/setup/base_setup"
require "bristle/util/core_extensions"
require "bristle/util/merger"

using Bristle::Util::CoreExtensions

module Bristle
  module Setup
    # Rake setup
    class VisualStudioCodeSetup < BaseSetup
      protected

      def setup_project
        workspace_file = Pathname("#{project.name}.code-workspace")

        task(name: "Checking '#{workspace_file}'") do
          workspace = workspace_file.if_exist?&.json || {}
          updates = project.editor(:vscode)&.workspace&.to_json_value || {}

          workspace = Util::Merger.new.merge(source: updates, target: workspace)
          workspace_file.update(content: "#{JSON.pretty_generate(workspace)}\n", binmode: false) ? "(updated)" : true
        end
      end
    end
  end
end
