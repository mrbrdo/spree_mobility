# Core Spree is biased towards SpreeGlobalize, so we need to prepend our versions
Rails.application.config.to_prepare do
  module SpreeMobilityApiV1TaxonSearch
    private
    def taxonomy
      if params[:taxonomy_id].present?
        @taxonomy ||=
            Spree::Taxonomy.includes(:translations, taxons: [:translations]).
            accessible_by(current_ability, :show).find(params[:taxonomy_id])
      end
    end
  end
  Spree::Api::V1::TaxonsController.prepend SpreeMobilityApiV1TaxonSearch
end
