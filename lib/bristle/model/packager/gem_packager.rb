# frozen_string_literal: true

require "bristle/model/packager/base_packager"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Packager
      # GitHub repository
      class GemPackager < BasePackager
        dsl_type :gem

        dsl_accessor :require_paths, map: Types::Bool, key: String.coerce, factory: -> { true }
        dsl_accessor :files, map: Types::Bool, key: String.coerce, factory: -> { true }

        def initialize
          @require_paths = {}
          @files = {}
        end
      end
    end
  end
end
