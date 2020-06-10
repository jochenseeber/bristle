# frozen_string_literal: true

require "bristle/util/dsl/extensions"
require "bristle/util/core_extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    # Developer information
    class Developer
      attr_reader :id

      dsl_accessor :name, primitive: String.strict
      dsl_accessor :email, primitive: String.strict

      def initialize(id:)
        @id = String.coerce[id]
      end
    end
  end
end
