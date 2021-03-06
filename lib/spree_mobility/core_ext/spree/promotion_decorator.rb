module SpreeMobility::CoreExt::Spree::PromotionDecorator
  def self.prepended(base)
    base.include SpreeMobility::Translatable
    SpreeMobility.translates_for base, :name, :description
    
    base.translation_class.class_eval do
      validates :name, presence: true
      validates :description, length: { maximum: 255 }, allow_blank: true
    end
  end
end
