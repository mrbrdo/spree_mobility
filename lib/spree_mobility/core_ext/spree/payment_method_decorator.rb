module SpreeMobility::CoreExt::Spree::PaymentMethodDecorator
  def self.prepended(base)
    base.include SpreeMobility::Translatable
    SpreeMobility.translates_for base, :name, :description

    base.translation_class.class_eval do
      validates :name, presence: true
    end

    # Fix for STI inheriting associations dependent on load-order
    base.descendants.each do |klass|
      next if klass.reflect_on_association(:translations)
      SpreeMobility.translates_for klass, :name, :description
      translations_assoc = base.reflect_on_association(:translations)
      klass.has_many :translations,
        class_name:  translations_assoc.class_name,
        inverse_of:  translations_assoc.inverse_of.name,
        foreign_key: translations_assoc.foreign_key,
        dependent: translations_assoc.options[:dependent],
        autosave: translations_assoc.options[:autosave],
        extend: translations_assoc.options[:extend]
    end
  end
end
