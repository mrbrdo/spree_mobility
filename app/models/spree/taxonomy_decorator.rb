module Spree::TaxonomyDecorator
  def self.prepended(base)
    base.translates :name
  end

  Spree::Taxonomy.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::Taxonomy, Spree::TaxonomyDecorator)
