module Spree::ProductPropertyDecorator
  def self.prepended(base)
    SpreeMobility.translates_for base, :value
  end

  Spree::ProductProperty.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::ProductProperty, Spree::ProductPropertyDecorator)
