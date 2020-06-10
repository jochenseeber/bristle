# frozen_string_literal: true

require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

require_relative "folder"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

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
        # Ruby linter settings
        class RubyLinter
          dsl_accessor :use_bundler, primitive: Types::Bool

          def to_json_value
            {
              "useBundler" => use_bundler,
            }
          end
        end
      end
    end
  end
end
