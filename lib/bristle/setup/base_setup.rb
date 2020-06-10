# frozen_string_literal: true

require "erubis"
require "rainbow/refinement"
require "tty/spinner"

require "bristle/util/core_extensions"

using Rainbow
using Bristle::Util::CoreExtensions

module Bristle
  module Setup
    # Base class for setups
    class BaseSetup
      CUSTOM_CONFIGURATION_PATTERN = %r{^\s*#\s*>>>[^\n]*$\n(?:^\s*$\n)*(.*?)(?:^\s*$\n)*^\s*#\s*<<<}m.freeze

      attr_reader :project
      attr_accessor :enabled

      def initialize(project:, enabled: true)
        @project = project
        @enabled = enabled
      end

      def setup
        return unless enabled

        setup_project
      end

      protected

      def task(name:)
        spinner = TTY::Spinner.new("[:spinner] #{name}", success_mark: "\u{2714}".green, error_mark: "\u{2716}".red)

        begin
          result = yield

          if result == false
            spinner.error("(failed)")
          elsif result == true
            spinner.success("")
          else
            spinner.success(result)
          end
        rescue StandardError => e
          spinner.error(e.message)
          raise e
        end
      end

      def template_task(target:, group:, template: nil, variables: {}, active:)
        target = Pathname(target)

        raise "Target must be a relative path instead of '#{target}'" unless target.relative?

        task(name: "Checking '#{target}'") do
          if active
            template ||= default_template_file(file: Pathname(group) + target)
            render_template(template: template, target: target, variables: variables)
          elsif target.file?
            Pathname(target).delete
            "(deleted)"
          else
            true
          end
        end
      end

      def default_template_file(file:)
        file = Pathname(file)

        raise "File must be a relative path instead of '#{file}'" unless file.relative?

        parts = Pathname(file).each_filename.map do |n|
          n.gsub(%r{\A\.+}, "")
        end

        Pathname(parts.join("/") + ".erb")
      end

      def render_template(template:, target:, variables: {})
        target = Pathname(target)

        template_file = Gem.find_files("bristle/templates/#{template}").first&.to_pathname
        raise "Unable to find template for '#{template}" unless template_file

        variables = variables.dup
        variables[:project] = project
        variables[:custom] ||= {}

        current_content = target.read_if_exist || ""
        custom_configuration = current_content[CUSTOM_CONFIGURATION_PATTERN, 1]&.chomp

        variables[:custom][:default] = custom_configuration if custom_configuration

        erb = Erubis::Eruby.new(template_file.read, filename: template_file.to_s)

        content = erb.result(variables)

        target.to_pathname.update(content: content, binmode: false) ? "(updated)" : true
      end

      def setup_project
        raise NotImplementedError, "Subclasses must implement"
      end
    end
  end
end
