# frozen_string_literal: true

module Bristle
  module Model
    module Repository
      # Repository base class
      class Base
        def type
          self.class.dsl_factory_type
        end
      end
    end
  end
end
