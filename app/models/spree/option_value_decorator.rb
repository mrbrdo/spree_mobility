module Spree::OptionValueDecorator
  def self.prepended(base)
    base.translates :name, :presentation, :fallbacks_for_empty_translations => true
  end

  Spree::OptionValue.include SpreeMobility::Translatable
end

::Spree::OptionValue.prepend(Spree::OptionValueDecorator)
