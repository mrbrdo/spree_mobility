module Spree::PropertyDecorator
  def self.prepended(base)
    base.translates :name, :presentation
  end

  Spree::Property.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::Property, Spree::PropertyDecorator)
