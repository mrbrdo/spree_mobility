module SpreeMobility
  # The fact this logic is in a single module also helps to apply a custom
  # locale on the spree/api context since api base controller inherits from
  # MetalController instead of Spree::BaseController
  module ControllerMobilityHelper
    extend ActiveSupport::Concern

    included do
      prepend_before_action :mobility_fallbacks

      private

      def mobility_fallbacks
        SpreeMobility::Fallbacks.config!
      end
    end
  end
end
