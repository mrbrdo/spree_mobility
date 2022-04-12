module Spree::PromotionDecorator
  def self.prepended(base)
    base.translates :name, :description
  end

  Spree::Promotion.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::Promotion, Spree::PromotionDecorator)
