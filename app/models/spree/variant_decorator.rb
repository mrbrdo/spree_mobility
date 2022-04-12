module Spree
  module VariantDecorator
    module ClassMethods
      def search_by_product_name_or_sku(query)
        joins(product: :translations).where("LOWER(#{Spree::Product::Translation.table_name}.name) LIKE LOWER(:query) OR LOWER(sku) LIKE LOWER(:query)",
                                            query: "%#{query}%")
      end
    end
  end
end

SpreeMobility.prepend_once(::Spree::Variant.singleton_class, Spree::VariantDecorator::ClassMethods)