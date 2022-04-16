require 'spree_i18n'
require 'spree_mobility/engine'
require 'spree_mobility/version'
require 'spree_mobility/fallbacks'
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
  end
end