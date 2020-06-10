# frozen_string_literal: true

require "yaml"

require "bristle/setup/base_setup"
require "bristle/util/core_extensions"

using Bristle::Util::CoreExtensions

module Bristle
  module Setup
    # Rubocop setup
    class GitSetup < BaseSetup
      protected

      def setup_project
        scm = project.scm
        return unless scm

        gitignore_file = (project.dir + ".gitignore").subpath(base: Pathname.pwd)

        task(name: "Checking '#{gitignore_file}'") do
          gitignore = gitignore_file.if_exist?(&:read)&.lines&.map(&:chomp) || []

          scm.filters.each do |path, type|
            filter = escape_filter(path: path, type: type)

            case type
            when :include, :exclude
              gitignore << filter unless gitignore.include?(filter)
            when :delete_include, :delete_exclude
              gitignore.delete(filter)
            else
              raise "Unknown filter type '#{type}'"
            end
          end

          gitignore = sorted_gitignore(lines: gitignore)

          gitignore_file.update(content: gitignore.join("\n") + "\n", binmode: false) ? "(changed)" : true
        end
      end

      def sorted_gitignore(lines:)
        return lines if lines.any? { |l| l.start_with?("#") }

        lines.sort! do |a, b|
          if a.start_with?("!") == b.start_with?("!")
            a <=> b
          elsif b.start_with?("!")
            -1
          else
            1
          end
        end
      end

      def escape_filter(path:, type:)
        path = path.gsub(%r{[#\\]}, "\\\\\\0")
        path = "!#{path}" if %i[include delete_include].include?(type)
        path
      end
    end
  end
end
