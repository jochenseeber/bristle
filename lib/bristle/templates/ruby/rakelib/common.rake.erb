# frozen_string_literal: true

require "rake/clean"

# Clean standard directories
CLEAN.include("build", "tmp")

# Clobber standard directories
CLOBBER.include("pkg", "generated", "embedded")

desc "Setup development environment"
task "setup"

desc "Check development environment"
task "check"

desc "Copy required project files into build"
task "copy" => "check"

desc "Generate required project files"
task "generate" => %w[check copy]

# Run generate and check before building
task "build" => %w[check copy generate]

desc "Validate source code"
task "validate"

# Run check before releasing
task "release" => %w[check validate build test]
