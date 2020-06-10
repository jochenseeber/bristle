# frozen_string_literal: true

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module TestMetric
      # Base class for test metrics tools
      class BaseTestMetric
        dsl_accessor :enabled, primitive: Types::Bool
      end
    end
  end
end
