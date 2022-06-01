module SpreeMobility::CoreExt::Spree::PaymentMethodDecorator
  def self.prepended(base)
    base.include SpreeMobility::Translatable
    SpreeMobility.translates_for base, :name, :description

    base.translation_class.class_eval do
      validates :name, presence: true
    end
  end
end
