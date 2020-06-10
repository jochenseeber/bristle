# frozen_string_literal: true

require "bristle/model/editor/visual_studio_code/workspace"
require "bristle/model/language/base"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Editor
      # Visual Studio code language settings
      class VisualStudioCodeEditor < Base
        dsl_type :vscode

        dsl_accessor :workspace, primitive: Hash

        protected

        def default_workspace
          VisualStudioCode::Workspace.new
        end
      end
    end
  end
end
