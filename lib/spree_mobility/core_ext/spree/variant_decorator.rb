module SpreeMobility::CoreExt::Spree
  module VariantDecorator
    module ClassMethods
      def product_name_or_sku_cont(query)
        helper =
          SpreeMobility::TranslationQuery.new(
            ::Spree::Product.mobility_backend_class(:name))

        helper.add_joins(self.joins(:product)).
        where(
          "(LOWER(#{helper.col_name(:name)}) LIKE LOWER(:query)) OR (LOWER(#{::Spree::Variant.table_name}.sku) LIKE LOWER(:query))", query: "%#{query}%").distinct
      end
      
      def search_by_product_name_or_sku(query)
        product_name_or_sku_cont(query)
      end
    end
  end
end
