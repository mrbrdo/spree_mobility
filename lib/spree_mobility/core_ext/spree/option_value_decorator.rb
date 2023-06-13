module SpreeMobility::CoreExt::Spree::OptionValueDecorator
  module TranslationMethods
    def name_uniqueness_validation
      return unless name.present?
      return unless translated_model
      check_scope =
        ::Spree::OptionValue.
        where.not(id: translated_model.id).
        where(option_type_id: translated_model.option_type_id).
        joins(:translations).
        where(spree_option_value_translations: { locale: locale }).
        where('LOWER(spree_option_value_translations.name) = ?', name.downcase)
      if check_scope.exists?
        errors.add(:name, :taken, value: name)
      end
    end
  end

  def self.prepended(base)
    base.include SpreeMobility::Translatable
    SpreeMobility.translates_for base, *base::TRANSLATABLE_FIELDS

    base.translation_class.class_eval do
      include TranslationMethods
      validate :name_uniqueness_validation
    end
  end
end
