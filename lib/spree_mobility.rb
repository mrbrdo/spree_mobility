require 'spree_i18n'
require 'spree_mobility/engine'
require 'spree_mobility/version'
require 'spree_mobility/fallbacks'
require 'deface'

module SpreeMobility
  def self.prepend_once(to_klass, klass)
    to_klass.prepend(klass) unless to_klass.ancestors.include?(klass)
  end
end