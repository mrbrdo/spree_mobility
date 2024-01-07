require 'spree_i18n'
require 'spree_mobility/engine'
require 'spree_mobility/version'
require 'spree_mobility/fallbacks'
require 'spree_mobility/translation_query'
require 'deface'

module SpreeMobility
  def self.prepend_once(to_klass, klass)
    to_klass.prepend(klass) unless to_klass.ancestors.include?(klass)
  end

  def self.clear_validations_for(klass, *attrs)
    attrs.each do |attr|
      klass.validators_on(attr).each { |val| val.attributes.delete(attr) }
    end
  end

  def self.translates_for(klass, *attrs)
    klass.translates(*attrs)
    clear_validations_for(klass, *attrs)

    # used for preloading only current locale and its fallbacks
    translations_assoc = klass.reflect_on_association(:translations)
    klass.has_many :active_translations,
      -> { where(locale: SpreeMobility.locale_with_fallbacks) },
      class_name:  translations_assoc.class_name,
      inverse_of:  translations_assoc.inverse_of.name,
      foreign_key: translations_assoc.foreign_key,
      dependent: translations_assoc.options[:dependent],
      autosave: translations_assoc.options[:autosave],
      extend: translations_assoc.options[:extend]
  end

  def self.locale_with_fallbacks
    result = [::Mobility.locale]
    begin
      # At the moment the easiest way to access Mobility fallbacks properly
      # is through a translated model's attribute
      backend = ::Spree::Product.mobility_backend_class(:name)
      result.concat(backend.fallbacks[::Mobility.locale])
      result.uniq!
    rescue KeyError # backend not found
    end
    result
  end

  def self.product_wysiwyg_editor_enabled?
    spree_backend_config :product_wysiwyg_editor_enabled
  end

  def self.taxon_wysiwyg_editor_enabled?
    spree_backend_config :taxon_wysiwyg_editor_enabled
  end

  def self.spree_backend_config(key)
    if defined?(Spree::Backend::Config) && Spree::Backend::Config.has_preference?(key)
      Spree::Backend::Config[key]
    else
      Spree::Config[key]
    end
  end

  def self.extend_reloadable_classes
    SpreeMobility.prepend_once(::Spree::Country, SpreeMobility::CoreExt::Spree::CountryDecorator)
    SpreeMobility.prepend_once(::Spree::OptionType, SpreeMobility::CoreExt::Spree::OptionTypeDecorator)
    SpreeMobility.prepend_once(::Spree::OptionValue, SpreeMobility::CoreExt::Spree::OptionValueDecorator)
    SpreeMobility.prepend_once(::Spree::Product, SpreeMobility::CoreExt::Spree::ProductDecorator)
    SpreeMobility.prepend_once(::Spree::Product.singleton_class, SpreeMobility::CoreExt::Spree::ProductDecorator::ClassMethods)
    SpreeMobility.prepend_once(::Spree::Product.singleton_class, SpreeMobility::CoreExt::Spree::ProductScopesWithMobilityDecorator)
    SpreeMobility.prepend_once(::Spree::ProductProperty, SpreeMobility::CoreExt::Spree::ProductPropertyDecorator)
    SpreeMobility.prepend_once(::Spree::Promotion, SpreeMobility::CoreExt::Spree::PromotionDecorator)
    SpreeMobility.prepend_once(::Spree::Property, SpreeMobility::CoreExt::Spree::PropertyDecorator)
    SpreeMobility.prepend_once(::Spree::ShippingMethod, SpreeMobility::CoreExt::Spree::ShippingMethodDecorator)
    SpreeMobility.prepend_once(::Spree::PaymentMethod, SpreeMobility::CoreExt::Spree::PaymentMethodDecorator)
    SpreeMobility.prepend_once(::Spree::Store, SpreeMobility::CoreExt::Spree::StoreDecorator)
    SpreeMobility.prepend_once(::Spree::Taxon, SpreeMobility::CoreExt::Spree::TaxonDecorator)
    SpreeMobility.prepend_once(::Spree::Taxonomy, SpreeMobility::CoreExt::Spree::TaxonomyDecorator)
    SpreeMobility.prepend_once(::Spree::Variant.singleton_class, SpreeMobility::CoreExt::Spree::VariantDecorator::ClassMethods)
    SpreeMobility.prepend_once(::Spree::Products::Find, SpreeMobility::CoreExt::Spree::Products::FindWithMobilityDecorator)
    SpreeMobility.prepend_once(::Spree::Locales::SetFallbackLocaleForStore, SpreeMobility::CoreExt::Spree::Locales::SetFallbackLocaleForStoreDecorator)
    
    ::Spree::Admin::TaxonomiesController.send :include, ::Spree::Admin::Translatable
  end
end
