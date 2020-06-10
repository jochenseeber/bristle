# frozen_string_literal: true

require "bristle/model/repository/base"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Repository
      # GitHub repository
      class Github < Base
        dsl_type :github

        dsl_accessor :user, primitive: String.coerce
        dsl_accessor :repository, primitive: String.coerce
      end
    end
  end
end
