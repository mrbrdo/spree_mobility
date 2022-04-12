module Spree::ProductPropertyDecorator
  def self.prepended(base)
    base.translates :value
  end

  Spree::ProductProperty.include SpreeMobility::Translatable
end

::Spree::ProductProperty.prepend(Spree::ProductPropertyDecorator)
