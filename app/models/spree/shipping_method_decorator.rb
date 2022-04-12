module Spree::ShippingMethodDecorator
  def self.prepended(base)
    base.translates :name
  end

  Spree::ShippingMethod.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::ShippingMethod, Spree::ShippingMethodDecorator)
