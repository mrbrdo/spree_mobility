module Spree::OptionTypeDecorator
  def self.prepended(base)
    SpreeMobility.translates_for base, :name, :presentation
    
    base.translation_class.class_eval do
      validates :name, presence: true, uniqueness: { scope: :locale, case_sensitive: false, allow_blank: true }
      validates :presentation, presence: true
    end
  end
  
  Spree::OptionType.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::OptionType, Spree::OptionTypeDecorator)
