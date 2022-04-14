module Spree::ProductScopesWithMobilityDecorator
  def ascend_by_taxons_min_position(taxon_ids)
    # order() must not refer to select(), because select could be removed
    # in Spree::Products::Find
    joins(:classifications).
      where(Spree::Classification.table_name => { taxon_id: taxon_ids }).
      select(
        [
          "#{Spree::Product.table_name}.*",
          "MIN(#{Spree::Classification.table_name}.position) AS min_position"
        ].join(', ')
      ).
      group(:id).
      order(Arel.sql("MIN(#{Spree::Classification.table_name}.position) ASC"))
  end
end

SpreeMobility.prepend_once(::Spree::Product.singleton_class, Spree::ProductScopesWithMobilityDecorator)