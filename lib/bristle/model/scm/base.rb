# frozen_string_literal: true

require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Scm
      FILTER_TYPE = Types::Symbol.enum(:include, :exclude, :delete_include, :delete_exclude)

      # SCM base class
      class Base
        dsl_accessor :filters, map: Symbol.coerce, key: String.coerce

        def initialize
          @filters = {}
        end

        def include(pattern)
          filter pattern, :include
        end

        def exclude(pattern)
          filter pattern, :exclude
        end
      end
    end
  end
end
