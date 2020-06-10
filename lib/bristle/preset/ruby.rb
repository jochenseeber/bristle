# frozen_string_literal: true

require "yaml"

require "bristle/model/linter/rubocop"
require "bristle/preset/preset"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Preset
    # Presets for Ruby projects
    class Ruby < Preset
      dsl_type :ruby

      dsl_accessor :minitest, primitive: Types::Bool | Gem::Requirement.coerce
      dsl_accessor :qed, primitive: Types::Bool | Gem::Requirement.coerce
      dsl_accessor :simplecov, primitive: Types::Bool | Gem::Requirement.coerce
      dsl_accessor :zeitwerk, primitive: Types::Bool | Gem::Requirement.coerce

      protected

      def update(project:)
        update_language(project: project)
        update_scm(project: project)
        update_builder(project: project)
        update_gem_packager(project: project)
        update_linter(project: project)
        update_test_runners(project: project)
        update_test_coverage(project: project)
        update_doc_generators(project: project)
      end

      def update_language(project:)
        project.language(:ruby) do
          version "2.6.6" if version.nil?
          required_version ">= #{(version.segments + [0, 0])[0..1].join(".")}" if required_version.nil?
        end

        effective_zeitwerk_version&.then do |v|
          project.dependency "zeitwerk" do
            type :runtime
            version v
          end
        end

        project.dependency "bundler" do
          type :development
          version "~> 2.1"
        end
      end

      def effective_zeitwerk_version
        case zeitwerk
        when Gem::Requirement
          zeitwerk
        when true
          default_zeitwerk_version
        end
      end

      def default_zeitwerk
        Gem::Requirement.new("~> 2.3")
      end

      def effective_qed_version
        case qed
        when Gem::Requirement
          qed
        when true
          default_qed_version
        end
      end

      def default_qed
        Gem::Requirement.new("~> 2.9")
      end

      def effective_minitest_version
        case minitest
        when Gem::Requirement
          minitest
        when true
          default_minitest_version
        end
      end

      def default_minitest
        Gem::Requirement.new("~> 5.14")
      end

      def effective_simplecov_version
        case simplecov
        when Gem::Requirement
          simplecov
        when true
          default_simplecov_version
        end
      end

      def default_simplecov
        Gem::Requirement.new("~> 0.18")
      end

      def update_gem_packager(project:)
        project.packager :gem do
          require_path "lib"

          file "*.md"
          file "*.txt"
          file "lib/**/*.rb" if (project.dir + "lib").exist?
          file "cmd/*" if (project.dir + "cmd").exist?
        end
      end

      def update_builder(project:)
        project.dependency "rake" do
          type :development
          version "~> 13.0"
        end
      end

      def update_scm(project:)
        return unless project.scm

        project.scm do
          exclude "/.bundle/"
          exclude "/build/"
          exclude "/generated/"
          exclude "/pkg/"
          exclude "/tmp/"
          exclude "/vendor/bundle/"
        end
      end

      def update_linter(project:)
        config_file = Gem.find_files("bristle/templates/ruby/rubocop.yml").first&.to_pathname
        raise "Unable to find YAML config file 'ruby/rubocop.yml'" unless config_file

        config = YAML.safe_load(config_file.read)

        project.linter(:rubocop) do
          settings config
        end

        project.dependency "rubocop" do
          type :development
          version [">= 0.85"]
        end
      end

      def update_doc_generators(project:)
        project.dependency "yard" do
          type :development
          version "~> 0.9"
        end
      end

      def update_test_runners(project:)
        effective_qed_version&.then do |v|
          project.test_runner(:qed) do
            enabled true
          end

          project.dependency "qed" do
            type :development
            version v
          end

          project.dependency "ae" do
            type :development
            version "~> 1.8"
          end
        end

        effective_minitest_version&.then do |v|
          project.test_runner(:minitest) do
            enabled true
          end

          project.dependency "minitest" do
            type :development
            version v
          end

          project.dependency "ae" do
            type :development
            version "~> 1.8"
          end
        end
      end

      def update_test_coverage(project:)
        effective_simplecov_version&.then do |v|
          project.test_metric(:simplecov)

          project.dependency "simplecov" do
            type :development
            version v
          end

          project.dependency "coveralls" do
            type :development
            version "= 0.8.23.js"
          end
        end
      end
    end
  end
end
