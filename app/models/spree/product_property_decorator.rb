module Spree::ProductPropertyDecorator
  def self.prepended(base)
    base.translates :value, fallbacks_for_empty_translations: true
  end

  Spree::ProductProperty.include SpreeMobility::Translatable
end

::Spree::ProductProperty.prepend(Spree::ProductPropertyDecorator)
