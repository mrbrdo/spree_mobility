module SpreeMobility::CoreExt::Spree::Products::FindWithMobilityDecorator
  # The issue here is that ordering by translated attr (e.g. name) will add
  # an ORDER BY translations_table.name, but the query has a SELECT DISTINCT,
  # which would require the translations_table.name to be added to the SELECT
  # Instead of using DISTINCT, we select the ID only and use that as a subquery
  # in a simple SELECT ... FROM products WHERE products.id IN (SUBQUERY).
  # Performance-wise should be almost the same, or the same.
  def execute
    ::Spree::Product.where(id: super.except(:select).select(:id).distinct(false))
  end
end

