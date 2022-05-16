require 'mobility'
require 'mobility/backends/active_record/table'

# Extend library classes
SpreeMobility.prepend_once(::Mobility::Backends::ActiveRecord::Table.singleton_class,
  SpreeMobility::CoreExt::Mobility::Backends::ActiveRecord::Table::MobilityActsAsParanoidDecorator)

Rails.application.config.to_prepare do
  # Extend reloadable classes
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
end
