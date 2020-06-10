# frozen_string_literal: true

require "bristle/model/repository/github"
require "bristle/preset/preset"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Preset
    # Presets for GitHub hosted projects
    class VisualStudioCodePreset < Preset
      dsl_type :vscode

      protected

      def update(project:)
        project.editor :vscode do
          enabled true
        end

        update_workspace(project: project, workspace: project.editor(:vscode).workspace)
      end

      def update_workspace(project:, workspace:)
        workspace.folder "." do
          name "#{project.name} Workspace"
        end

        workspace.settings do
          git_ignore_limit_warning true
          editor_format_on_save true
          ruby_use_bundler true
          ruby_use_language_server true
          ruby_linter :rubocop do
            use_bundler true
          end
        end
      end
    end
  end
end
