require 'mobility'
require 'friendly_id/mobility'

module SpreeMobility
  class Engine < Rails::Engine
    engine_name 'spree_mobility'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree_mobility.environment", before: :load_config_initializers do |app|
      SpreeMobility::Config = SpreeMobility::Configuration.new
    end

    config.to_prepare do
      SpreeMobility.extend_reloadable_classes
    end

    initializer "spree_mobility.permitted_attributes", before: :load_config_initializers do |app|
      taxon_attributes = { translations_attributes: [:id, :locale, :name, :description, :permalink, :meta_description, :meta_keywords, :meta_title] }
      Spree::PermittedAttributes.taxon_attributes << taxon_attributes

      option_value_attributes = { translations_attributes: [:id, :locale, :name, :presentation] }
      Spree::PermittedAttributes.option_value_attributes << option_value_attributes

      store_attributes = { translations_attributes: [:id, :locale, :name, :meta_description, :meta_keywords, :seo_title] }
      Spree::PermittedAttributes.store_attributes << store_attributes
    end

    def self.activate
      Dir.glob(File.join(root, "app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
