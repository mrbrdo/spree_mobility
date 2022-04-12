module Spree::OptionTypeDecorator
  def self.prepended(base)
    base.translates :name, :presentation
  end
  
  Spree::OptionType.include SpreeMobility::Translatable
end

::Spree::OptionType.prepend(Spree::OptionTypeDecorator)
