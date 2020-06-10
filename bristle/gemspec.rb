# frozen_string_literal: true

spec.files += Dir["lib/**/*.yaml"]

spec.required_ruby_version = ">= 2.6"

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

spec.add_development_dependency "ae", "~> 1.8"
spec.add_development_dependency "bundler", "~> 2.1"
spec.add_development_dependency "coveralls", "~> 0.8"
spec.add_development_dependency "qed", "~> 2.9"
spec.add_development_dependency "rake", "~> 13.0"
spec.add_development_dependency "yard", "~> 0.8"
