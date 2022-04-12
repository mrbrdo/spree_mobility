module Spree::OptionValueDecorator
  def self.prepended(base)
    base.translates :name, :presentation
  end

  Spree::OptionValue.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::OptionValue, Spree::OptionValueDecorator)
