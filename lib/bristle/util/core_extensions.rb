# frozen_string_literal: true

require "digest"
require "fileutils"
require "json"
require "pathname"
require "tempfile"

module Bristle
  module Util
    # Extensions for core ruby classes
    module CoreExtensions
      refine Object do
        def to_pathname
          Pathname(to_s)
        end
      end

      refine Pathname.singleton_class do
        def temp_file(prefix: nil, suffix: nil, binmode:)
          basename = [prefix, suffix].compact.then { |n| n.empty? ? "" : n }

          Tempfile.open(basename, binmode: binmode) do |f|
            yield(f) if block_given?
          rescue StandardError
            raise "Error creating temporary file '#{f.path}'"
          ensure
            f.close!
          end
        end
      end

      refine Pathname do
        def to_pathname
          self
        end

        def if_exist?
          if exist?
            if block_given?
              yield(self)
            else
              self
            end
          end
        end

        def read_if_exist(default: nil)
          if exist?
            read
          elsif block_given?
            result = yield(self)
            result.nil? ? default : result
          end
        end

        def subpath(base: Pathname.pwd)
          if relative?
            self
          else
            relative_path = relative_path_from(base)

            if relative_path.descend.first.to_s == ".."
              self
            else
              relative_path
            end
          end
        end

        def sha256
          Digest::SHA2.hexdigest(read(binmode: true))
        end

        def json
          JSON.parse(read)
        end

        def modified?(target:)
          target = Pathname(target)

          !target.exist? || size != target.size || sha256 != target.sha256
        end

        def copy(target:, mode: nil)
          target = Pathname(target)

          modified = if modified?(target: target)
            target.dirname.mkpath
            FileUtils.cp(to_path, target.to_path)
            true
          else
            false
          end

          unless mode.nil? || stat.mode == target.stat.mode
            target.chmod(state.mode)
            modified = true
          end

          modified
        end

        def update(content:, binmode:)
          Pathname.temp_file(prefix: basename.to_s, suffix: extname, binmode: binmode) do |f|
            f.write(content)
            f.close

            Pathname(f).copy(target: to_path)
          end
        end

        def basepart
          basename(extname)
        end

        def match(pattern)
          case pattern
          when String
            fnmatch(pattern, File::FNM_EXTGLOB)
          when Regexp
            pattern =~ to_path
          else
            raise "Pattern '#{pattern}' has illegal type '#{pattern.class}'"
          end
        end

        def to_json_value
          to_path
        end
      end

      refine Class do
        def descendants
          descendants = []

          ObjectSpace.each_object(singleton_class) do |cls|
            descendants << cls if !cls.singleton_class? && !cls.equal?(self)
          end

          descendants
        end
      end

      [NilClass, String, Numeric, TrueClass, FalseClass].each do |c|
        refine c do
          def to_json_value
            self
          end
        end
      end

      [Symbol, Pathname].each do |c|
        refine c do
          def to_json_value
            to_s
          end
        end
      end

      refine Array do
        def to_json_value
          map(&:to_json_value)
        end
      end

      refine Hash do
        def to_json_value
          each_with_object({}) do |(key, value), result|
            result[key.to_json_value] = value.to_json_value
          end
        end
      end
    end
  end
end
