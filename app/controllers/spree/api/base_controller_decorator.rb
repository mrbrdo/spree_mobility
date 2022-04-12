module Spree::Api::BaseControllerDecorator
  Spree::Api::BaseController.include(SpreeMobility::ControllerMobilityHelper)
end

SpreeMobility.prepend_once(::Spree::Api::BaseController, Spree::Api::BaseControllerDecorator)
