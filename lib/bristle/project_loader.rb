# frozen_string_literal: true

require "bristle/model/builder/rake"
require "bristle/model/editor/visual_studio_code_editor"
require "bristle/model/language/ruby"
require "bristle/model/linter/rubocop"
require "bristle/model/packager/gem_packager"
require "bristle/model/project"
require "bristle/model/repository/github"
require "bristle/model/scm/git"
require "bristle/model/test_runner/minitest_runner"
require "bristle/model/test_runner/qed_runner"
require "bristle/preset/common"
require "bristle/preset/github"
require "bristle/preset/ruby"
require "bristle/preset/visual_studio_code_preset"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions
using Bristle::Util::CoreExtensions

module Bristle
  # Load project data
  class ProjectLoader
    NAME_TYPE = Util::Dsl::NAME_TYPE

    def initialize
      @preset_types = {}
    end

    def load(dir:)
      dir = Pathname.coerce[dir]
      project = Model::Project.new(dir: dir, loader: self)

      project.register_repository(factory: Model::Repository::Github)

      project.register_scm(factory: Model::Scm::Git)

      project.register_language(factory: Model::Language::Ruby)

      project.register_builder(factory: Model::Builder::Rake)

      project.register_packager(factory: Model::Packager::GemPackager)

      project.register_editor(factory: Model::Editor::VisualStudioCodeEditor)

      project.register_linter(factory: Model::Linter::Rubocop)

      project.register_test_runner(factory: Model::TestRunner::MinitestRunner)
      project.register_test_runner(factory: Model::TestRunner::QedRunner)

      project.register_test_metric(factory: Model::TestMetric::SimplecovMetric)

      project.register_preset(factory: Preset::Common)
      project.register_preset(factory: Preset::Github)
      project.register_preset(factory: Preset::Ruby)
      project.register_preset(factory: Preset::VisualStudioCodePreset)

      project.preset :common
      project.preset :github
      project.preset :ruby
      project.preset :vscode

      load_config(project: project, file: dir + "project.json")

      project.presets.each_value do |preset|
        preset.apply(project: project)
      end

      project
    end

    def load_config(project:, file:)
      case file.extname.downcase
      when ".bristle"
        load_dsl_config(project: project, file: file)
      when ".json"
        load_json_config(project: project, file: file)
      else
        raise ArgumentError, "Unsupported configuration format '#{file}'"
      end
    end

    def create_preset(type:)
      preset_type = @preset_types[type] || raise(ArgumentError, "No preset registered for type '#{type}")
      preset_type.new
    end

    protected

    def load_dsl_config(project:, file:)
      file_name = file.to_s
      code = file.read

      Docile.dsl_eval(project) do
        instance_eval(code, file_name)
      end

      project
    end

    def load_json_config(project:, file:)
      config = JSON.parse(file.read)
      project.dsl_apply_configuration(config: config)
      project
    end
  end
end
