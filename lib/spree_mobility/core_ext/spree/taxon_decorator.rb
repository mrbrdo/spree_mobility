module SpreeMobility::CoreExt::Spree::TaxonDecorator
  module TranslationMethods
    def permalink_uniqueness_validation
      return unless permalink.present?
      return unless translated_model
      check_scope =
        ::Spree::Taxon.
        where.not(id: translated_model.id).
        where(parent_id: translated_model.parent_id,
          taxonomy_id: translated_model.taxonomy_id).
        joins(:translations).
        where(spree_taxon_translations: { locale: locale }).
        where('LOWER(spree_taxon_translations.permalink) = ?', permalink.downcase)
      if check_scope.exists?
        errors.add(:permalink, :taken, value: permalink)
      end
    end

    def name_uniqueness_validation
      return unless name.present?
      return unless translated_model
      check_scope =
        ::Spree::Taxon.
        where.not(id: translated_model.id).
        where(parent_id: translated_model.parent_id,
          taxonomy_id: translated_model.taxonomy_id).
        joins(:translations).
        where(spree_taxon_translations: { locale: locale }).
        where('LOWER(spree_taxon_translations.name) = ?', name.downcase)
      if check_scope.exists?
        errors.add(:name, :taken, value: name)
      end
    end
  end

  def self.prepended(base)
    base.include SpreeMobility::Translatable
    SpreeMobility.translates_for base, :name, :description, :meta_title,
      :meta_description, :meta_keywords, :permalink
    base.friendly_id :permalink, slug_column: :permalink, use: [:history, :mobility]

    base.translation_class.class_eval do
      include TranslationMethods
      validates :name, presence: true
      validate :name_uniqueness_validation
      with_options length: { maximum: 255 }, allow_blank: true do
        validates :meta_keywords
        validates :meta_description
        validates :meta_title
      end
      validate :permalink_uniqueness_validation
    end
  end
end
