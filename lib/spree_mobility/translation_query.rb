module SpreeMobility
  class TranslationQuery
    def initialize(mobility_backend_class)
      @mobility_backend_class = mobility_backend_class
    end

    def add_joins(search_scope)
      fallback_locales.each do |locale|
        search_scope =
          @mobility_backend_class.
          send(:join_translations, search_scope, locale, ::Arel::Nodes::OuterJoin)
      end
      search_scope
    end

    def col_name(attr)
      select_columns = []
      fallback_locales.each do |locale|
        select_columns << "#{table_alias(locale)}.#{attr}"
      end
      "COALESCE(#{select_columns.join(',')})"
    end

    private

    def fallback_locales
      # Cache this result, since Mobility.locale will not change
      # during this class's lifetime
      @fallback_locales ||= SpreeMobility.locale_with_fallbacks
    end

    def table_alias(locale)
      @mobility_backend_class.table_alias(locale)
    end
  end
end