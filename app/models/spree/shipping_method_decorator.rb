module Spree::ShippingMethodDecorator
  def self.prepended(base)
    SpreeMobility.translates_for base, :name
    
    base.translation_class.class_eval do
      validates :name, presence: true
    end
  end

  Spree::ShippingMethod.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::ShippingMethod, Spree::ShippingMethodDecorator)
