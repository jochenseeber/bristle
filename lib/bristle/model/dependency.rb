# frozen_string_literal: true

require "bristle/util/dsl/extensions"
require "bristle/util/core_extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    # Project dependency
    class Dependency
      TYPE_TYPE = Types::Symbol.enum(:runtime, :development)

      attr_reader :id

      dsl_accessor :type, primitive: TYPE_TYPE
      dsl_accessor :version, primitive: Gem::Requirement.coerce

      def initialize(id:)
        @id = id
      end
    end
  end
end
