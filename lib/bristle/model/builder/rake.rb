# frozen_string_literal: true

require "bristle/model/builder/base"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Builder
      # Rake bulder settings
      class Rake < Base
        dsl_type :rake
      end
    end
  end
end
