# frozen_string_literal: true

require "bristle/util/dry_extensions"

using Bristle::Util::DryExtensions

module Bristle
  module Util
    module Dsl
      NAME_TYPE = Symbol.strict.constrained(format: %r{\A[a-z][a-z0-9_]*\z})

      TYPE_TYPE = Types.Instance(Dry::Types::Type).constructor { |v| v.is_a?(Dry::Types::Type) ? v : v.strict }

      INFLECTOR = Dry::Inflector.new

      # Class for the empty object
      class EmptyClass
        def to_s
          "(empty)"
        end
      end

      EMPTY = EmptyClass.new.freeze
    end
  end
end
