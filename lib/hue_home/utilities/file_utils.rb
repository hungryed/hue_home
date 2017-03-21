require 'fileutils'

module HueHome
  module Utilities
    class FileUtilities
      class << self
        def mkdir_p(*filepaths)
          ::FileUtils.mkdir_p(path_for(*filepaths))
        end

        def path_for(*filepaths)
          File.join(base_path, *filepaths)
        end

        def base_path
          filepath = "#{Dir.home}/#{storage_path}"
          ::FileUtils.mkdir_p(filepath)
          filepath
        end

        def storage_path
          configuration.storage_path_relative_to_home
        end

        def configuration
          HueHome.configuration
        end
      end
    end
  end
end
