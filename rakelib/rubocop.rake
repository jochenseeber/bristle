# frozen_string_literal: true

desc "Run Rubocop checks"
task "rubocop:validate" do
  sh "bundle exec rubocop --fail-level=C --cache=true"
end

task "validate" => "rubocop:validate"
