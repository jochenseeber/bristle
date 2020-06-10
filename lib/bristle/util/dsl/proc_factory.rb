# frozen_string_literal: true

require "bristle/util/dry_extensions"
require "bristle/util/dsl/factory"

using Bristle::Util::DryExtensions

module Bristle
  module Util
    module Dsl
      # Converts strings or symbols into named objects of a specific type
      class ProcFactory < Factory
        ARGUMENT_NAMES = %i[accessor target value].freeze

        attr_reader :factory

        def initialize(proc:)
          @proc = proc
          @parameters = proc.parameters.select { |type, _| %i[key keyreq].include?(type) }.map { |_, name| name }
        end

        def create(accessor:, target:, value:)
          if value.is_a?(String) || value.is_a?(Symbol)
            arguments = {
              accessor: accessor,
              target: target,
              value: value,
            }.slice(*@parameters)

            if arguments.empty?
              @proc.call
            else
              @proc.call(**arguments)
            end
          else
            value
          end
        end
      end
    end
  end
end
