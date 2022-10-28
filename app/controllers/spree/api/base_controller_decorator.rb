module Spree::Api::BaseControllerDecorator
  def self.api_base_klass
    if defined?(::Spree::Api::V1::BaseController)
      ::Spree::Api::V1::BaseController
    elsif defined?(::Spree::Api::BaseController)
      ::Spree::Api::BaseController
    end
  end
  api_base_klass.include(SpreeMobility::ControllerMobilityHelper) if api_base_klass
end

api_base_klass = Spree::Api::BaseControllerDecorator.api_base_klass
SpreeMobility.prepend_once(api_base_klass, Spree::Api::BaseControllerDecorator) if api_base_klass
