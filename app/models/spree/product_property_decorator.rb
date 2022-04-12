module Spree::ProductPropertyDecorator
  def self.prepended(base)
    base.translates :value
  end

  Spree::ProductProperty.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::ProductProperty, Spree::ProductPropertyDecorator)
