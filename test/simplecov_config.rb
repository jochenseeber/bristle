# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_filter "/demo/"
  add_filter "/test/"
  add_filter "/tmp/"
  coverage_dir "build/coverage"
end
