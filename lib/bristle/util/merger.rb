# frozen_string_literal: true

module Bristle
  module Util
    # Merge a source object into a target object
    class Merger
      def merge(source:, target:)
        case source
        when nil
          target
        when String, Numeric, TrueClass, FalseClass
          source
        when Array
          merge_array(source: source, target: target)
        when Hash
          merge_hash(source: source, target: target)
        else
          raise ArgumentError, "Cannot merge with a '#{source.class}' as source"
        end
      end

      protected

      def merge_array(source:, target:)
        if target.nil?
          target = []
        elsif !target.is_a?(Array)
          raise ArgumentError, "Target for array merge must be an array or nil"
        end

        source.each do |source_entry|
          if source_entry.is_a?(Hash)
            merge_entry_into_array(source_entry: source_entry, target: target)
          else
            target << source
          end
        end

        target
      end

      def merge_entry_into_array(source_entry:, target:)
        id, id_value = source_entry.find { |k, _v| k.start_with?("^") }

        if id.nil?
          target << source_entry
        else
          id_name = id[1..]
          source_entry = source_entry.transform_keys { |k| k.delete_prefix("^") }
          target_entry = target.find { |e| e[id_name] == id_value }

          if target_entry.nil?
            target << source_entry
          else
            merge_hash(source: source_entry, target: target_entry)
          end
        end
      end

      def merge_hash(source:, target:)
        if target.nil?
          target = {}
        elsif !target.is_a?(Hash)
          raise ArgumentError, "Target for hash merge must be a hash or nil, not '#{target}' (#{target.class})"
        end

        source.each do |source_key, source_value|
          target_value = target[source_key]
          target[source_key] = merge(source: source_value, target: target_value)
        end

        target
      end
    end
  end
end
