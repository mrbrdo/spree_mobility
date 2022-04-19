module SpreeMobility::CoreExt::Spree::ShippingMethodDecorator
  def self.prepended(base)
    base.include SpreeMobility::Translatable
    SpreeMobility.translates_for base, :name
    
    base.translation_class.class_eval do
      validates :name, presence: true
    end
  end
end
