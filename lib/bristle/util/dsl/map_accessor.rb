# frozen_string_literal: true

require "bristle/util/dry_extensions"
require "bristle/util/dsl/accessor.rb"

using Bristle::Util::DryExtensions

module Bristle
  module Util
    module Dsl
      # Base class for scalar DSL accessors
      class MapAccessor < Accessor
        attr_reader :default_entry_method
        attr_reader :entry_method
        attr_reader :configured_method
        attr_reader :factory

        def initialize(name:, type:, entry: nil, factory: nil)
          super(name: name, type: type)

          entry = (entry || singular_name).to_sym

          raise "Entry name '#{entry}' cannot be the same as the accessor name '#{name}'" if entry == name

          @entry_method = entry
          @default_entry_method = :"default_#{entry}"
          @configured_method = :"#{entry}_configured"
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

          target.define_method(entry_method) do |key, entry = EMPTY, &block|
            accessor.access_entry(target: self, key: key, entry: entry, &block)
          end

          factory&.setup(target: target, accessor: accessor)
        end

        def configure(target:, config:)
          if config == true
            config = {}
          elsif !config.is_a?(Hash)
            raise "Config must be 'true' or a Hash"
          end

          value = access_value(target: target)

          if value.nil?
            value = {}
            target.send(set_method, value)
          end

          configure_entries(target: target, value: value, config: config) unless config.empty?
        end

        def access_entry(target:, key:, entry:, &block)
          if entry == EMPTY
            get_entry(target: target, key: key, &block)
          else
            set_entry(target: target, key: key, entry: entry, &block)
          end
        end

        def get_entry(target:, key:, &block)
          value = access_value(target: target, value: EMPTY)
          store = false

          entry = value&.fetch(key) do
            if factory
              store = true
              factory.create(accessor: self, target: target, value: key)
            end
          end

          if block
            raise "Cannot configure empty '#{singular_name}' entry for key '#{key}'" if entry.nil?

            Docile.dsl_eval(entry, &block)
          end

          value.store(key, entry) if store

          if (store || block) && target.respond_to?(configured_method)
            target.send(configured_method, key, converted_entry)
          end

          entry
        end

        def set_entry(target:, key:, entry:, &block)
          value = access_value(target: target, value: EMPTY)

          value[key] = entry

          if block
            raise "Cannot configure empty '#{singular_name}' entry for key '#{key}'" if entry.nil?

            Docile.dsl_eval(entry, &block)
          end

          value.store(key, entry)

          target.send(configured_method, key, converted_entry) if target.respond_to?(configured_method)

          entry
        end

        def set_value(target:, value:)
          target.instance_variable_set(variable, type[value].dup)
        end

        protected

        def configure_entries(target:, value:, config:)
          key_type = type.key_type
          default_available = target.respond_to?(default_entry_method)

          config.each do |k, v|
            k = key_type[k]
            entry = value[k]

            if entry.nil?
              entry = if !factory.nil?
                factory.create(accessor: self, target: target, value: k)
              elsif default_available
                target.send(default_entry_method, key: k)
              end
            end

            if entry.nil?
              raise "Cannot configure empty entry with key '#{k}' in '#{name}' of #{target} (#{target.class})"
            end

            Dsl::Extensions.apply_configuration(target: entry, config: v) if v != true

            target.send(entry_method, k, entry)
          end
        end
      end
    end
  end
end
