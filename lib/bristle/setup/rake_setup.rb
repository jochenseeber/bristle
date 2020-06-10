# frozen_string_literal: true

require "yaml"

using Bristle::Util::CoreExtensions

module Bristle
  module Setup
    # Rake setup
    class RakeSetup < BaseSetup
      protected

      def setup_project
        template_task(target: "Rakefile", group: "ruby", active: true)
        template_task(target: "rakelib/common.rake", group: "ruby", active: true)
        template_task(target: "rakelib/gem.rake", group: "ruby", active: project.packagers.key?(:gem))
        template_task(target: "rakelib/github.rake", group: "ruby", active: project.repository&.type == :github)
        template_task(target: "rakelib/minitest.rake", group: "ruby", active: project.test_runners.key?(:minitest))
        template_task(target: "rakelib/qed.rake", group: "ruby", active: project.test_runners.key?(:qed))
        template_task(target: "rakelib/rubocop.rake", group: "ruby", active: project.linters.key?(:rubocop))
      end
    end
  end
end
