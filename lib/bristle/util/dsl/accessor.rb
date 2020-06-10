# frozen_string_literal: true

require "bristle/types"
require "bristle/util/dry_extensions"
require "bristle/util/dsl"

using Bristle::Util::DryExtensions

module Bristle
  module Util
    module Dsl
      # Accessor base class
      class Accessor
        attr_reader :name
        attr_reader :type
        attr_reader :access_method
        attr_reader :set_method
        attr_reader :default_method
        attr_reader :variable
        attr_reader :singular_name

        def initialize(name:, type:)
          @name = NAME_TYPE[name]
          @type = TYPE_TYPE[type]
          @access_method = name
          @set_method = :"#{@name}="
          @default_method = :"default_#{@name}"
          @variable = :"@#{@name}"
          @singular_name = INFLECTOR.singularize(@name).to_sym
        end

        def define(target:)
          setup(target: target)
          @converter&.setup(target: target, accessor: self)
        end

        def setup(target:)
          raise NotImplementedError, "Subclasses must implement"
        end

        def configure(target:, value:)
          raise NotImplementedError, "Subclasses must implement"
        end

        def access_value(target:, value: EMPTY)
          if value.equal?(EMPTY)
            result = target.instance_variable_get(variable)

            if result.nil?
              default_value(target: target)
            else
              result
            end
          else
            target.send(set_method, value)
          end
        end

        def default_value(target:)
          if target.respond_to?(default_method, true)
            target.instance_variable_set(variable, target.send(default_method))
          end
        end

        def set_value(target:, value:)
          target.instance_variable_set(variable, type[value])
        end
      end
    end
  end
end
