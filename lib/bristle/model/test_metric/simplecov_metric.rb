# frozen_string_literal: true

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module TestMetric
      # Base class for Simplecov
      class SimplecovMetric < BaseTestMetric
        dsl_type :simplecov
      end
    end
  end
end
