module Spree::PropertyDecorator
  def self.prepended(base)
    base.translates :name, :presentation
  end

  # Currently, mobilize does not yet support fallbacks in query scopes,
  # so we update this method to fetch property IDs instead of value and then let
  # mobilize logic determine the correct translation.
  # The performance impact in this case should be minimal.
  def uniq_values(product_properties_scope: nil)
    with_uniq_values_cache_key(product_properties_scope) do
      properties = product_properties
      properties = properties.where(id: product_properties_scope) if product_properties_scope.present?
      
      filter_params_scope = properties.reorder(nil).group(:filter_param).select(Arel.sql('MAX(id)'))
      properties.where(id: filter_params_scope).
      includes(:translations).sort_by(&:value).
      map { |property| [property.filter_param, property.value] }
    end
  end

  Spree::Property.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::Property, Spree::PropertyDecorator)
