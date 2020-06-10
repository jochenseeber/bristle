# frozen_string_literal: true

require "bristle/util/dry_extensions"
require "bristle/util/dsl/accessor.rb"

using Bristle::Util::DryExtensions

module Bristle
  module Util
    module Dsl
      # Base class for scalar DSL accessors
      class ObjectAccessor < Accessor
        CONFIG_TYPE = TrueClass.strict | Hash.strict

        attr_reader :factory

        def initialize(name:, type:, factory: nil)
          super(name: name, type: type)

          @factory = Factory.optional[factory]
        end

        def setup(target:)
          accessor = self

          target.define_method(access_method) do |value = EMPTY, &block|
            accessor.access_value(target: self, value: value, &block)
          end

          target.define_method(set_method) do |value|
            accessor.set_value(target: self, value: value)
          end

          factory&.setup(target: target, accessor: accessor)
        end

        def access_value(target:, value:, &block)
          store = false

          current_value = super(target: target, value: EMPTY, &block)

          if !value.equal?(EMPTY) && current_value.nil? && type.try(value).failure? && !factory.nil?
            current_value = factory.create(target: target, accessor: self, value: value)
            store = true
          end

          Docile.dsl_eval(current_value, &block) unless block.nil? || current_value.nil?

          target.send(set_method, current_value) if store

          current_value
        end

        def configure(target:, config:)
          raise "Object mus be a Hash with one entry" unless config.is_a?(Hash) && config.size == 1

          type, properties = config.first

          value = target.send(access_method, type)

          raise "Cannot configure empty property '#{name}'" if value.nil?

          Dsl::Extensions.apply_configuration(target: value, config: properties) if properties != true
        end
      end
    end
  end
end
