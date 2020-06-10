# frozen_string_literal: true

require "bristle/model/linter/base"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Linter
      # Ruby language settings
      class Rubocop < Base
        VALUE_TYPE = String.strict | Numeric.strict | Types::Array.of(String.strict)

        dsl_type :rubocop

        dsl_accessor :settings, map: Types.Map(String.coerce, Object.strict), key: String.coerce, factory: -> { {} }
      end
    end
  end
end
