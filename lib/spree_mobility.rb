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
    klass.accepts_nested_attributes_for :translations
    klass.whitelisted_ransackable_associations ||= []
    klass.whitelisted_ransackable_associations << 'translations'
    clear_validations_for(klass, *attrs)

    # used for preloading only current locale and its fallbacks
    translations_assoc = klass.reflect_on_association(:translations)
    klass.has_many :active_translations,
      -> { where(locale: SpreeMobility.locale_with_fallbacks) },
      class_name:  translations_assoc.class_name,
      inverse_of:  translations_assoc.inverse_of.name,
      foreign_key: translations_assoc.foreign_key
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
end