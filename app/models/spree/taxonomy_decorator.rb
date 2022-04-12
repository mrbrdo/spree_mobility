module Spree::TaxonomyDecorator
  def self.prepended(base)
    base.translates :name
  end

  Spree::Taxonomy.include SpreeMobility::Translatable
end

::Spree::Taxonomy.prepend(Spree::TaxonomyDecorator)
