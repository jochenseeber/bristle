# frozen_string_literal: true

desc "Run QED tests"
task "qed:test" do
  if Rake.verbose == true
    sh "qed -I lib -I test -p coverage -v"
  else
    sh "qed -I lib -I test -p coverage"
  end
end

desc "Run tests"
task "test" => %w[generate qed:test]

task "release" => "test"
