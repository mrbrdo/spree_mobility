module Spree
  module Admin
    module ShippingMethodsControllerDecorator
      private
      # We have to override those filters since they break proper PATCH behaviour.

      def set_shipping_category
        super unless params['shipping_method'][:translations_attributes]
      end

      def set_zones
        super unless params['shipping_method'][:translations_attributes]
      end
    end
  end
end

SpreeMobility.prepend_once(::Spree::Admin::ShippingMethodsController, Spree::Admin::ShippingMethodsControllerDecorator)
