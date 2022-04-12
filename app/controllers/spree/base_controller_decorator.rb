module Spree::BaseControllerDecorator
  Spree::BaseController.include(SpreeMobility::ControllerMobilityHelper)
end

::Spree::BaseController.prepend(Spree::BaseControllerDecorator)
