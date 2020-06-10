# frozen_string_literal: true

require "bristle/model/scm/base"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::Dsl::Extensions
using Bristle::Util::DryExtensions

module Bristle
  module Model
    module Scm
      # SCM base class
      class Git < Base
        dsl_type :git
      end
    end
  end
end
