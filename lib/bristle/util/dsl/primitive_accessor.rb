# frozen_string_literal: true

require "bristle/util/dry_extensions"
require "bristle/util/dsl/accessor.rb"

using Bristle::Util::DryExtensions

module Bristle
  module Util
    module Dsl
      # Base class for primitive DSL accessors
      class PrimitiveAccessor < Accessor
        def setup(target:)
          accessor = self

          target.define_method(access_method) do |value = EMPTY|
            accessor.access_value(target: self, value: value)
          end

          target.define_method(set_method) do |value|
            accessor.set_value(target: self, value: value)
          end
        end

        def configure(target:, config:)
          set_value(target: target, value: config)
        end
      end
    end
  end
end
