# frozen_string_literal: true

require "bristle/model/language/base"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Coverage
      # Ruby language settings
      class SimpleCov < Base
        dsl_type :simplecov
      end
    end
  end
end
