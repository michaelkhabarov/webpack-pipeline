require 'webpack/configuration'
require 'webpack/error'

module Webpack
  class Manifest
    include Singleton

    cattr_reader :configuration do
      @configuration ||= Configuration.new
    end

    def self.configure
      yield configuration
    end

    def asset_url(source)
      if configuration.raise_on_errors && data['errors'].present?
        raise Webpack::CompileError, data['errors'].split('\n').join("\n")
      end

      asset_name = asset_in_chunks(source) || asset_images(source)
      "#{host}#{asset_name}" if asset_name
    end

    def host
      data['publicPath']
    end

    protected

    def asset_in_chunks(source)
      name = source.split('.').first
      ext  = source.split('.').last
      chunk = [*data['assetsByChunkName'][name]]

      chunk.find { |asset| asset.end_with? ext }
    end

    def asset_images(source)
      data['assets'].present? ? data['assets'][source] : source
    end

    def data
      new_timestamp = File.ctime(configuration.path)
      return @data if new_timestamp == @updated_at
      @updated_at = new_timestamp
      @data = JSON.parse(File.read(configuration.path))
    end
  end
end
