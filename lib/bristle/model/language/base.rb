# frozen_string_literal: true

using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Language
      # Base class for languages
      class Base
        dsl_accessor :version, primitive: Gem::Version.coerce
        dsl_accessor :required_version, primitive: Gem::Requirement.coerce
      end
    end
  end
end
