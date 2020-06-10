# frozen_string_literal: true

require "bristle/util/dsl"

require "bristle/util/dsl/extensions"

using Bristle::Util::Dsl::Extensions

module Bristle
  module Preset
    # Base class for presets
    class Preset
      NAME_TYPE = Util::Dsl::NAME_TYPE

      dsl_accessor :enabled, primitive: Types::Bool

      def initialize(enabled: true)
        @enabled = enabled
      end

      def apply(project:)
        return unless enabled

        update(project: project)
      end

      protected

      def update(project:); end
    end
  end
end
