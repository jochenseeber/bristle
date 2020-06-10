# frozen_string_literal: true

require "dry/types"
require "pathname"
require "uri"

module Bristle
  # Types used
  module Types
    include Dry.Types(:optional, :coercible, default: :strict)

    Pathname = Types.Instance(::Pathname)
    URI = Types.Instance(::URI)
    Version = Types.Instance(::Gem::Version)
    Requirement = Types.Instance(::Gem::Requirement)

    Coercible.const_set(:Pathname, Types::Pathname.constructor { |v| Kernel.Pathname(v) })
    Coercible.const_set(:URI, Types::URI.constructor { |v| Kernel.URI(v) })
    Coercible.const_set(:Version, Types::Version.constructor { |v| ::Gem::Version.new(v) })
    Coercible.const_set(:Requirement, Types::Requirement.constructor { |v| ::Gem::Requirement.new(v) })
  end
end
