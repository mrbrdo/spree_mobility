module SpreeMobility::CoreExt::Spree::ShippingMethodDecorator
  def self.prepended(base)
    base.include SpreeMobility::Translatable
    base::TRANSLATABLE_FIELDS ||= %i[name].freeze
    SpreeMobility.translates_for base, *base::TRANSLATABLE_FIELDS
    
    base.translation_class.class_eval do
      validates :name, presence: true
    end
  end
end
