# frozen_string_literal: true

require "bristle/model/language/base"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Language
      # Ruby language settings
      class Ruby < Base
        dsl_type :ruby

        dsl_accessor :zeitwerk, primitive: Gem::Requirement.coerce
      end
    end
  end
end
