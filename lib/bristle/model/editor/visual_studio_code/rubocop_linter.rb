# frozen_string_literal: true

require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

require "bristle/model/editor/visual_studio_code/ruby_linter"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Editor
      module VisualStudioCode
        # Ruby linter settings
        class RubocopLinter < RubyLinter
          dsl_type :rubocop
        end
      end
    end
  end
end
