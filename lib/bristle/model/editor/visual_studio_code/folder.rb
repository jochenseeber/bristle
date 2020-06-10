# frozen_string_literal: true

require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Editor
      module VisualStudioCode
        # Workspace configuration
        class Folder
          attr_reader :path

          dsl_accessor :name, primitive: String.coerce

          def initialize(path:)
            @path = Pathname.coerce[path]
          end

          def to_json_value
            {
              "^path" => path.to_json_value,
              "name" => name,
            }
          end
        end
      end
    end
  end
end
