# frozen_string_literal: true

#
# Generated by bristle. Changes outside the custom configuration section will be overwritten.
#
require "json"
require "pathname"

Gem::Specification.new do |spec|
  raise "RubyGems 2.0 or newer is required." unless spec.respond_to?(:metadata)

  spec.name = "bristle"
  spec.version = "0.1.0.dev"
  spec.summary = "Clean as a whistle!"

  spec.required_ruby_version = ">= 2.6"

  spec.authors = ["Jochen Seeber"]
  spec.email = ["jochen@seeber.me"]
  spec.homepage = "https://github.com/jochenseeber/bristle"

  spec.metadata["issue_tracker"] = "https://github.com/jochenseeber/bristle/issues"
  spec.metadata["documentation"] = "http://jochenseeber.github.com/bristle"
  spec.metadata["source_code"] = "https://github.com/jochenseeber/bristle"
  spec.metadata["wiki"] = "https://github.com/jochenseeber/bristle/wiki"

  spec.files = Dir[
    "*.md",
    "*.txt",
    "lib/**/*.rb",
    "cmd/*",
  ]

  spec.require_paths = [
    "lib",
  ]

  spec.bindir = "cmd"
  spec.executables = spec.files.filter { |f| File.dirname(f) == "cmd" && File.file?(f) }.map { |f| File.basename(f) }

  spec.add_dependency "zeitwerk", "~> 2.3"

  spec.add_development_dependency "ae", "~> 1.8"
  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "coveralls", "= 0.8.23.js"
  spec.add_development_dependency "qed", "~> 2.9"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", ">= 0.85"
  spec.add_development_dependency "simplecov", "~> 0.18"
  spec.add_development_dependency "yard", "~> 0.9"

  # >>> Custom configuration
  spec.files += Dir["lib/bristle/templates/**/*"]

  spec.add_dependency "clamp", "~> 1.3"
  spec.add_dependency "docile", "~> 1.3"
  spec.add_dependency "down", "~> 5.1"
  spec.add_dependency "dry-inflector", "~> 0.2"
  spec.add_dependency "dry-types", "~> 1.4"
  spec.add_dependency "erubis", "~> 2.7"
  spec.add_dependency "http", "~> 4.4"
  spec.add_dependency "minitar", "~> 0.9"
  spec.add_dependency "rainbow", "~> 3.0"
  spec.add_dependency "rubyzip", "~> 2.3"
  spec.add_dependency "tty-spinner", "~> 0.9"
  # <<< Custom configuration
end
