# frozen_string_literal: true

require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

require "bristle/model/editor/visual_studio_code/folder"
require "bristle/model/editor/visual_studio_code/settings"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Editor
      module VisualStudioCode
        # Workspace configuration
        class Workspace
          dsl_accessor :folders, map: Folder.strict, key: Pathname.coerce,
                                 factory: ->(value:) { Folder.new(path: value) }
          dsl_accessor :settings, object: Settings

          def initialize
            @folders = {}
            @settings = Settings.new
          end

          def to_json_value
            {
              "folders" => folders.values.to_json_value,
              "settings" => settings.to_json_value,
            }
          end
        end
      end
    end
  end
end
