# frozen_string_literal: true

require "bristle/util/dry_extensions"
require "bristle/util/dsl/factory"

using Bristle::Util::DryExtensions

module Bristle
  module Util
    module Dsl
      # Converts strings or symbols into objects of registered types
      class RegistryFactory < Factory
        attr_reader :factories_variable
        attr_reader :register_method

        def setup(accessor:, target:)
          @factories_variable = :"@#{accessor.singular_name}_factories"
          @register_method = :"register_#{accessor.singular_name}"

          accessor = self

          target.define_method(register_method) do |factory:|
            accessor.store_factory(target: self, factory: factory)
          end
        end

        def store_factory(target:, factory:)
          factories = target.instance_variable_get(factories_variable)

          if factories.nil?
            factories = {}
            target.instance_variable_set(factories_variable, factories)
          end

          factories.store(Symbol.strict[factory.dsl_factory_type], factory)
        end

        def create(accessor:, target:, value:)
          if value.is_a?(String) || value.is_a?(Symbol)
            factory = target.instance_variable_get(factories_variable)&.[](value.to_sym)
            raise ArgumentError, "Unknown factory '#{value}' for property '#{accessor.name}''" if factory.nil?

            factory.new
          else
            value
          end
        end
      end
    end
  end
end
