# frozen_string_literal: true

require "docile"
require "pathname"

require "bristle/util/dsl/extensions"
require "bristle/util/core_extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    # License file
    class License
      attr_reader :id

      dsl_accessor :text, primitive: String.strict

      def initialize(id:)
        @id = id
      end
    end
  end
end
