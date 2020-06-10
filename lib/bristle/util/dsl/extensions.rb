# frozen_string_literal: true

require "dry/inflector"

require "bristle"

using Bristle::Util::DryExtensions
using Bristle::Util::CoreExtensions

module Bristle
  module Util
    module Dsl
      # Extensions for DSL support
      module Extensions
        # DSL utilities
        refine Object.singleton_class do
          def dsl_accessor(name, primitive: nil, object: nil, map: nil, key: nil, factory: nil, **options) # rubocop:disable Metrics/ParameterLists
            factory = case factory
            when Class
              factory.new
            when Proc
              ProcFactory.new(proc: factory)
            else
              factory
            end

            accessor = if primitive
              PrimitiveAccessor.new(name: name, type: primitive, **options)
            elsif object
              ObjectAccessor.new(name: name, type: object, factory: factory, **options)
            elsif map
              MapAccessor.new(name: name, type: Types::Hash.map(key, map), factory: factory, **options)
            else
              raise "Please specify the type for accessor '#{name}'"
            end

            register_dsl_accessor(accessor: accessor)
          end

          def register_dsl_accessor(accessor:)
            accessor.freeze

            accessors = if class_variable_defined?(:@@dsl_accessors)
              class_variable_get(:@@dsl_accessors)
            else
              accessors = {}
              class_variable_set(:@@dsl_accessors, accessors)
            end

            raise "DSL accessor '#{accessor.name}' already defined" if accessors.key?(accessor.name)

            accessors[accessor.name] = accessor
            accessor.define(target: self)
          end

          def dsl_accessors
            if class_variable_defined?(:@@dsl_accessors)
              class_variable_get(:@@dsl_accessors).dup
            else
              {}
            end
          end

          def dsl_accessor_for(name:)
            Dsl::Extensions.accessor(type: self, name: name)
          end

          def dsl_type(type)
            type = NAME_TYPE[type]

            define_singleton_method(:dsl_factory_type) do
              type
            end
          end
        end

        def self.accessor(type:, name:)
          name = NAME_TYPE[name.to_sym]

          unless type.class_variable_defined?(:@@dsl_accessors)
            raise ArgumentError, "Unknown DSL accessor '#{name}' for type '#{type}'"
          end

          accessors = type.class_variable_get(:@@dsl_accessors)
          accessors[name] || raise(ArgumentError, "Unknown DSL accessor '#{name}' for type '#{type}'")
        end

        def self.apply_configuration(target:, config:)
          config.each do |name, value|
            accessor = accessor(type: target.class, name: name)
            accessor.configure(target: target, config: value)
          end
        end

        refine Object do
          def dsl_apply_configuration(config:)
            Dsl::Extensions.apply_configuration(target: self, config: config)
          end

          def dsl_json_value
            raise "Class '#{self.class}' is not a DSL class" unless self.class.class_variable_defined?(:@@dsl_accessors)

            self.class.dsl_accessors.values.each_with_object({}) do |accessor, json|
              value = accessor.access_value(target: self, value: EMPTY)
              json[accessor.name] = value.dsl_json_value
            end
          end
        end

        [NilClass, String, Symbol, Numeric, TrueClass, FalseClass].each do |c|
          refine c do
            def dsl_json_value
              self
            end
          end
        end

        refine Array do
          def dsl_json_value
            map(&:dsl_json_value)
          end
        end

        refine Hash do
          def dsl_json_value
            each_with_object({}) do |(key, value), result|
              result[key.dsl_json_value] = value.dsl_json_value
            end
          end
        end

        [Gem::Version, Gem::Requirement, URI].each do |c|
          refine c do
            def dsl_json_value
              to_s
            end
          end
        end
      end
    end
  end
end
