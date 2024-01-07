module SpreeMobility
  module Fallbacks
    # Prevents the app from breaking when a translation is not present on the
    # default locale. It should search for translations in all supported
    # locales
    #
    # It needs to build a proper key value hash for every locale. So that a locale
    # always fallbacks to itself first before looking at the default and then
    # to any other. e.g
    #
    #   supported_locales = [:es, :de, :en]
    #
    #   # right
    #   { en: [:en, :de, :es], es: [:es, :en, :de] .. }
    #
    #   # wrong, spanish locale would fallback to english first
    #   { en: [:en, :es], es: [:en, :es] }
    #
    #   # wrong, spanish locale would fallback to german first instead of :en (default)
    #   { en: [:en, :de, :es], es: [:es, :de, :en] .. }
    #
    def self.get_fallbacks(store = nil)
      supported =
        if store
          store.supported_locales_list
        elsif Spree::Store.respond_to?(:available_locales) && Spree::Store.available_locales.any?
          Spree::Store.available_locales
        else
          [:en]
        end
      default =
        if store
          store.default_locale
        else
          I18n.default_locale.to_s
        end

      supported.each_with_object({}) do |locale, object|
        if locale == default
          object[locale] = (supported-[locale]).flatten
        else
          object[locale] = [default].push(supported-[locale, default]).flatten
        end
      end
    end
  end
end
