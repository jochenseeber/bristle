# frozen_string_literal: true

require "bristle/model/repository/github"
require "bristle/preset/preset"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Preset
    # Presets for GitHub hosted projects
    class Common < Preset
      dsl_type :common

      protected

      def update(project:)
        project.scm :git if (project.dir + ".git").directory?

        project.scm do
          exclude ".DS_Store"
          exclude "*~"
          exclude "#*#"
        end
      end
    end
  end
end
