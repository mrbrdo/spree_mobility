module SpreeMobility::CoreExt::Spree::Products::FindWithMobilityDecorator
  private

  # Order by name with support for Mobility fallback locales

  # Additional issue here is that ordering by translated attr (e.g. name) will add
  # an ORDER BY translations_table.name, but the query has a SELECT DISTINCT,
  # which would require the translations_table.name to be added to the SELECT
  # So when the order is added, the appropriate SELECT should be added as well.
  def ordered(products)
    case sort_by
    when 'name-a-z'
      ordered_name(products, :asc)
    when 'name-z-a'
      ordered_name(products, :desc)
    else
      super
    end
  end

  def ordered_name(products, direction)
    helper = SpreeMobility::TranslationQuery.new(::Spree::Product.mobility_backend_class(:name))
    helper.add_joins(products).
    select(products.arel.projections, "#{helper.col_name(:name)} AS _name").
    order(Arel.sql(helper.col_name(:name) + ((direction == :desc) ? ' DESC' : '')))
  end
end
