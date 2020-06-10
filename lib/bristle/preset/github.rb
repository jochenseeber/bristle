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
    class Github < Preset
      dsl_type :github

      dsl_accessor :user, primitive: String.coerce
      dsl_accessor :repository, primitive: String.coerce

      protected

      def update(project:)
        repository ||= project.name

        (project.repository ||= Model::Repository::Github.new).then do |repo|
          repo.user = user
          repo.repository = repository
        end

        project.homepage_url = "https://github.com/#{user}/#{repository}"
        project.ticket_system_url = "https://github.com/#{user}/#{repository}/issues"
        project.source_code_url = "https://github.com/#{user}/#{repository}"
        project.documentation_url = "http://#{user}.github.com/#{repository}"
        project.wiki_url = "https://github.com/#{user}/#{repository}/wiki"
      end
    end
  end
end
