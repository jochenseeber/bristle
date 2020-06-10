# frozen_string_literal: true

require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Linter
      # Repository base class
      class Base
        dsl_accessor :version, primitive: Gem::Requirement.coerce
      end
    end
  end
end
