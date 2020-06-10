# frozen_string_literal: true

require "bristle/util/dry_extensions"

using Bristle::Util::DryExtensions

module Bristle
  module Util
    module Dsl
      # Base class for converters
      class Factory
        def setup(target:, accessor:); end

        def create(target:, accessor:, value:)
          raise NotImplementedException, "Subclasses must implemented"
        end
      end
    end
  end
end
