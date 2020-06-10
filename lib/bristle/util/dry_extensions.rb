# frozen_string_literal: true

require "bristle/types"

module Bristle
  module Util
    # Extensions for dry stuff
    module DryExtensions
      refine Module do
        def strict
          @strict ||= begin
            type_name = name.split("::").last.to_sym

            type = if Bristle::Types.const_defined?(type_name)
              type = Bristle::Types.const_get(type_name)
              type if type.is_a?(Dry::Types::Type)
            end

            type = Bristle::Types.Instance(self) if type.nil?
            type
          end
        end

        def optional
          @optional ||= begin
            type_name = name.split("::").last

            if Bristle::Types::Optional.const_defined?(type_name)
              Bristle::Types::Optional.const_get(type_name)
            else
              strict.optional
            end
          end
        end

        def coerce
          @coerce ||= begin
            type_name = name.split("::").last

            type = if Bristle::Types::Coercible.const_defined?(type_name)
              type = Bristle::Types::Coercible.const_get(type_name)
              type if type.is_a?(Dry::Types::Type)
            end

            raise "Cannot find coercible type for '#{self}'" unless type

            type
          end
        end
      end

      refine TrueClass.singleton_class do
        def strict
          Bristle::Types::True
        end
      end

      refine FalseClass.singleton_class do
        def strict
          Bristle::Types::False
        end
      end
    end
  end
end
