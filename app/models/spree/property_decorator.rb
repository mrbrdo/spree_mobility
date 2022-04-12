module Spree::PropertyDecorator
  def self.prepended(base)
    base.translates :name, :presentation
  end

  Spree::Property.include SpreeMobility::Translatable
end

::Spree::Property.prepend(Spree::PropertyDecorator)
