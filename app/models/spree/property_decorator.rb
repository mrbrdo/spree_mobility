module Spree::PropertyDecorator
  def self.prepended(base)
    base.translates :name, :presentation, fallbacks_for_empty_translations: true
  end

  Spree::Property.include SpreeMobility::Translatable
end

::Spree::Property.prepend(Spree::PropertyDecorator)
