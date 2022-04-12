module Spree::Api::BaseControllerDecorator
  Spree::Api::BaseController.include(SpreeMobility::ControllerMobilityHelper)
end

::Spree::Api::BaseController.prepend(Spree::Api::BaseControllerDecorator)
