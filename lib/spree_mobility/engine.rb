require 'mobility'
require 'friendly_id/mobility'
require 'spree_api_v1'
require 'spree_mobility/configuration'

dir = File.expand_path("../", __FILE__)
Dir.glob("#{dir}/core_ext/**/*.rb").sort.each do |fn|
  require fn
end

module SpreeMobility
  class Engine < ::Rails::Engine
    engine_name 'spree_mobility'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree_mobility.environment", before: :load_config_initializers do |app|
      SpreeMobility::Config = SpreeMobility::Configuration.new
    end

    config.to_prepare do
      SpreeMobility.extend_reloadable_classes
    end

    initializer "let the main autoloader ignore this engine's overrides" do
      overrides = root.join("app/overrides")
      Rails.autoloaders.main.ignore(overrides)
    end

    def self.activate
      Dir.glob(File.join(root, "app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/overrides/*.rb")) do |c|
        load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
