module Spree
  module Admin
    module StatesControllerDecorator
      def translations
        @resource = Spree::State.find(params[:id])
      end

      private

      def parent
        if parent_data.present?
          base_scope = parent_data[:model_class].try(:for_store, current_store) || parent_data[:model_class]
    
          @parent ||= base_scope.
                      send(:find_by, parent_data[:find_by].to_s => params["#{base_scope.model_name.param_key}_id"])
          instance_variable_set("@#{base_scope.model_name.param_key}", @parent)
    
          raise ActiveRecord::RecordNotFound if @parent.nil?
    
          @parent
        end
      end
    end
  end
end

SpreeMobility.prepend_once(::Spree::Admin::StatesController, Spree::Admin::StatesControllerDecorator)