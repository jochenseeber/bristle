# frozen_string_literal: true

require "bristle/setup/base_setup"
require "bristle/util/core_extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions

module Bristle
  module Setup
    # Setup ruby project
    class RubySetup < BaseSetup
      protected

      def setup_project
        template_task(target: "Gemfile", group: "ruby", active: true)
        template_task(target: "#{project.name}.gemspec", group: "ruby", template: "ruby/gemspec.erb", active: true)
        template_task(target: ".ruby-version", group: "ruby", active: true)

        setup_test_runners
      end

      def setup_test_runners
        template_task(target: "test/simplecov_config.rb", group: "ruby", active: project.test_metrics.key?(:simplecov))
        template_task(target: "demo/applique/util.rb", group: "ruby", active: project.test_runners.key?(:qed))
        template_task(target: "etc/qed.rb", group: "ruby", active: project.test_runners.key?(:qed))
        template_task(target: ".github/workflows/test.yml", group: "ruby", active: project.repository&.type == :github)
      end
    end
  end
end
