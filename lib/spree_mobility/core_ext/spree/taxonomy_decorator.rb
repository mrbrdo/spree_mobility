module SpreeMobility::CoreExt::Spree::TaxonomyDecorator
  module TranslationMethods
    def name_uniqueness_validation
      return unless name.present?
      return unless translated_model
      check_scope =
        ::Spree::Taxonomy.
        where.not(id: translated_model.id).
        where(store_id: translated_model.store_id).
        joins(:translations).
        where(spree_taxonomy_translations: { locale: locale }).
        where('LOWER(spree_taxonomy_translations.name) = ?', name.downcase)
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
      validates :name, presence: true
      validate :name_uniqueness_validation
    end
  end
end
