# Core Spree is biased towards SpreeGlobalize, so we need to prepend our versions
Rails.application.config.to_prepare do
  module SpreeMobilityAdminTaxonSearch
    private
    def load_taxonomy
      @taxonomy = scope.includes(:translations, taxons: [:translations]).find(params[:taxonomy_id])
    end
  end
  Spree::Admin::TaxonsController.prepend SpreeMobilityAdminTaxonSearch

  module SpreeMobilityAdminStoreSearch
    def load_stores_by_query
      @stores = 
        stores_scope.joins(:translations).where("LOWER(#{Spree::Store::Translation.table_name}.name) LIKE LOWER(:query)",
                                                query: "%#{params[:q]}%")
    end
  end
  Spree::Admin::StoresController.prepend SpreeMobilityAdminStoreSearch

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