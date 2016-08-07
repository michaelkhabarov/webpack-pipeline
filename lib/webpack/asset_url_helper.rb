module Webpack
  module AssetUrlHelper
    extend ActiveSupport::Concern

    included do
      def compute_asset_path(source, options = {})
        webpack.asset_url(source) || raise(AssetNotFound, %{could not find asset "#{source}" in webpack manifest "#{Manifest.instance.configuration.path}"})
      end

      protected

      def webpack
        @webpack ||= Manifest.instance
      end
    end
  end
end
