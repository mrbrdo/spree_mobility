module Spree::TaxonDecorator
  module TranslationMethods
    def permalink_uniqueness_validation
      return unless permalink.present?
      return unless translated_model
      check_scope =
        Spree::Taxon.
        where.not(id: translated_model.id).
        where(parent_id: translated_model.parent_id,
          taxonomy_id: translated_model.taxonomy_id).
        joins(:translations).
        where(spree_taxon_translations: { locale: locale }).
        where('LOWER(spree_taxon_translations.permalink) = LOWER(?)', permalink)
      if check_scope.exists?
        errors.add(:permalink, :taken, value: permalink)
      end
    end
  end

  def self.prepended(base)
    base.translates :name, :description, :meta_title, :meta_description, :meta_keywords,
      :permalink
    base.friendly_id :permalink, slug_column: :permalink, use: [:history, :mobility]
    
    base.translation_class.validate :permalink_uniqueness_validation
    base.translation_class.include TranslationMethods
  end

  Spree::Taxon.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::Taxon, Spree::TaxonDecorator)
