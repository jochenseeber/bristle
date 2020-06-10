# frozen_string_literal: true

require "bristle/model/test_runner/base_test_runner"
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
      class MinitestRunner < BaseTestRunner
        dsl_type :minitest
      end
    end
  end
end
