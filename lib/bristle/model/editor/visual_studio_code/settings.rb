# frozen_string_literal: true

require "bristle/model/editor/visual_studio_code/rubocop_linter"
require "bristle/util/core_extensions"
require "bristle/util/dry_extensions"
require "bristle/util/dsl/extensions"

using Bristle::Util::CoreExtensions
using Bristle::Util::DryExtensions
using Bristle::Util::Dsl::Extensions

module Bristle
  module Model
    module Editor
      module VisualStudioCode
        # Settings
        class Settings
          dsl_accessor :git_ignore_limit_warning, primitive: Types::Bool
          dsl_accessor :editor_format_on_save, primitive: Types::Bool
          dsl_accessor :ruby_use_bundler, primitive: Types::Bool
          dsl_accessor :ruby_use_language_server, primitive: Types::Bool
          dsl_accessor :ruby_linters, map: String.coerce, key: RubyLinter.strict, factory: Util::Dsl::RegistryFactory

          def initialize
            @ruby_linters = {}
            register_ruby_linter(factory: RubocopLinter)
          end

          def to_json_value
            {
              "git.ignoreLimitWarning" => git_ignore_limit_warning,
              "editor.formatOnSave" => editor_format_on_save,
              "ruby.useBundler" => ruby_use_bundler,
              "ruby.useLanguageServer" => ruby_use_language_server,
              "ruby.lint" => ruby_linters.to_json_value,
            }
          end
        end
      end
    end
  end
end
