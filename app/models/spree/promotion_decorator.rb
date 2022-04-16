module Spree::PromotionDecorator
  def self.prepended(base)
    SpreeMobility.translates_for base, :name, :description
    
    base.translation_class.class_eval do
      validates :name, presence: true
      validates :description, length: { maximum: 255 }, allow_blank: true
    end
  end

  Spree::Promotion.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::Promotion, Spree::PromotionDecorator)
