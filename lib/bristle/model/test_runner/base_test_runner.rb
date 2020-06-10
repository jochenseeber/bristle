# frozen_string_literal: true

require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module TestRunner
      # Base class for test runners
      class BaseTestRunner
        dsl_accessor :enabled, primitive: Types::Bool
      end
    end
  end
end
