module Spree::OptionTypeDecorator
  def self.prepended(base)
    base.translates :name, :presentation
  end
  
  Spree::OptionType.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::OptionType, Spree::OptionTypeDecorator)
