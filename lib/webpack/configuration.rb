module Webpack
  class Configuration
    include ActiveSupport::Configurable

    config_accessor(:path) { File.join('config', 'manifest.json') }
    config_accessor(:raise_on_compilation_errors) { false }
  end
end
