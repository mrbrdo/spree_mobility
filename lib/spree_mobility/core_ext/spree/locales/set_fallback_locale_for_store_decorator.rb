module SpreeMobility::CoreExt
  module Spree
    module Locales
      module SetFallbackLocaleForStoreDecorator
        def call(store:)
          fallbacks = ::SpreeMobility::Fallbacks.get_fallbacks(store)

          fallbacks_instance = I18n::Locale::Fallbacks.new(fallbacks)

          ::Mobility.store_based_fallbacks = fallbacks_instance
        end
      end
    end
  end
end