# frozen_string_literal: true

require "docile"
require "json"
require "pathname"
require "bristle"

require "bristle/model/builder/base"
require "bristle/model/developer"
require "bristle/model/editor/base"
require "bristle/model/language/base"
require "bristle/model/license"
require "bristle/model/linter/base"
require "bristle/model/packager/base_packager"
require "bristle/model/repository/base"
require "bristle/model/scm/base"
require "bristle/model/dependency"
require "bristle/preset/preset"
require "bristle/project_loader"
require "bristle/types"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"
require "bristle/util/dsl/registry_factory"

using Bristle::Util::CoreExtensions
using Bristle::Util::Dsl::Extensions
using Bristle::Util::DryExtensions

module Bristle
  module Model
    # Project information
    class Project
      VERSION_TYPE = Types.Instance(Gem::Version).constructor do |v|
        v.is_a?(Gem::Version) ? v : Gem::Version.new(v.to_s.gsub("-", "."))
      end

      attr_reader :dir

      dsl_accessor :presets, map: Preset::Preset.strict, key: Symbol.coerce, factory: Util::Dsl::RegistryFactory

      dsl_accessor :name, primitive: String.strict
      dsl_accessor :version, primitive: VERSION_TYPE
      dsl_accessor :summary, primitive: String.strict
      dsl_accessor :description, primitive: String.strict

      dsl_accessor :dependencies,
                   map: Dependency.strict,
                   key: String.coerce,
                   factory: ->(value:) { Dependency.new(id: value) }

      dsl_accessor :license, object: License.strict, factory: ->(value:) { License.new(id: value) }

      dsl_accessor :developers,
                   map: Developer.strict,
                   key: String.coerce,
                   factory: ->(value:) { Developer.new(id: value) }

      dsl_accessor :repository, object: Repository::Base.strict, factory: Util::Dsl::RegistryFactory
      dsl_accessor :homepage_url, primitive: URI.coerce
      dsl_accessor :ticket_system_url, primitive: URI.coerce
      dsl_accessor :source_code_url, primitive: URI.coerce
      dsl_accessor :documentation_url, primitive: URI.coerce
      dsl_accessor :wiki_url, primitive: URI.coerce

      dsl_accessor :language, object: Language::Base.strict, factory: Util::Dsl::RegistryFactory

      dsl_accessor :scm, object: Scm::Base.strict, factory: Util::Dsl::RegistryFactory

      dsl_accessor :builders, map: Builder::Base.strict, factory: Util::Dsl::RegistryFactory
      dsl_accessor :packagers, map: Packager::BasePackager.strict, factory: Util::Dsl::RegistryFactory
      dsl_accessor :linters, map: Linter::Base.strict, key: Symbol.coerce, factory: Util::Dsl::RegistryFactory
      dsl_accessor :editors, map: Editor::Base.strict, key: Symbol.coerce, factory: Util::Dsl::RegistryFactory
      dsl_accessor :test_runners, map: TestRunner::BaseTestRunner.strict, key: Symbol.coerce,
                                  factory: Util::Dsl::RegistryFactory
      dsl_accessor :test_metrics, map: TestMetric::BaseTestMetric.strict, key: Symbol.coerce,
                                  factory: Util::Dsl::RegistryFactory

      def initialize(dir:, loader:)
        @dir = Pathname.coerce[dir]
        @loader = ProjectLoader.strict[loader]

        @builders = {}
        @dependencies = {}
        @developers = {}
        @editors = {}
        @linters = {}
        @packagers = {}
        @presets = {}
        @test_runners = {}
        @test_metrics = {}
      end

      def load_config(file:)
        file = Pathname.coerce[file].expand_path(dir)
        @loader.load_config(project: self, file: file)
      end
    end
  end
end
