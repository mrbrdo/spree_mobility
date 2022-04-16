module Spree::TaxonomyDecorator
  module TranslationMethods
    def name_uniqueness_validation
      return unless name.present?
      return unless translated_model
      check_scope =
        Spree::Taxonomy.
        where.not(id: translated_model.id).
        where(store_id: translated_model.store_id).
        joins(:translations).
        where(spree_taxonomy_translations: { locale: locale }).
        where('LOWER(spree_taxonomy_translations.name) = LOWER(?)', name)
      if check_scope.exists?
        errors.add(:name, :taken, value: name)
      end
    end
  end
  
  def self.prepended(base)
    base.translates :name
    
    base.translation_class.class_eval do
      include TranslationMethods
      validates :name, presence: true
      validate :name_uniqueness_validation
    end
  end

  Spree::Taxonomy.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::Taxonomy, Spree::TaxonomyDecorator)
