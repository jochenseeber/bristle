# frozen_string_literal: true

require "clamp"

require "bristle/model/project"
require "bristle/project_loader"

module Bristle
  module Command
    # Base class for commands
    class BaseCommand < Clamp::Command
      protected

      def loader
        @loader ||= ProjectLoader.new
      end

      def project
        @project ||= begin
          loader.load(dir: Pathname.pwd)
        end
      end

      def print_motto
        puts "Clean as a whistle!"
      end
    end
  end
end
