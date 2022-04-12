module Spree::BaseControllerDecorator
  Spree::BaseController.include(SpreeMobility::ControllerMobilityHelper)
end

SpreeMobility.prepend_once(::Spree::BaseController, Spree::BaseControllerDecorator)
