# frozen_string_literal: true

using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Editor
      # Editor base class
      class Base
        dsl_accessor :enabled, primitive: Types::Bool
      end
    end
  end
end
