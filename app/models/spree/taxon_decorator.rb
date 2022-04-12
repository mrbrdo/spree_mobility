module Spree::TaxonDecorator
  def self.prepended(base)
    base.translates :name, :description, :meta_title, :meta_description, :meta_keywords,
      :permalink
    base.friendly_id :permalink, slug_column: :permalink, use: [:history, :mobility]
  end

  Spree::Taxon.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::Taxon, Spree::TaxonDecorator)
