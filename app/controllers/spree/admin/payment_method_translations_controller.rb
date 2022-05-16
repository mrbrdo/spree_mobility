module Spree
  module Admin
    class PaymentMethodTranslationsController < Spree::Admin::BaseController
      def translate
        # Need to manually update translations, otherwise Rails
        # accepts_nested_attributes_for in combination with current mobility
        # implementation has some problems with the subclasses used with
        # PaymentMethods
        payment_method = Spree::PaymentMethod.find(params[:id])

        translations_params =
          params.require(:payment_method).permit(
            [translations_attributes: [:id, :locale, :name, :description]])

        payment_method.translations.delete_all
        translations_params[:translations_attributes].each_pair do |k, value|
          payment_method.translations.create(value)
        end

        flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:payment_method))
        redirect_to spree.edit_admin_payment_method_path(payment_method)
      end
    end
  end
end
