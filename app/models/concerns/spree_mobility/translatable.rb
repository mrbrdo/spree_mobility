module SpreeMobility
  module Translatable
    extend ActiveSupport::Concern

    include Spree::RansackableAttributes

    included do |klass|
      klass.send :extend, Mobility
      klass.send(:default_scope) { i18n }
    end

    class_methods do
      def translation_class
        const_get('Translation')
      end
      
      def ransack(params = {}, options = {})
        params ||= {}
        names = params.keys

        # TODO: this should be used together with search param, only fallback if first is empty
        # params[:translations_locale_in] ||= fallback_locales.map(&:to_s)

        names.each do |n|
          mobility_attributes.each do |t|
            if n.to_s.starts_with? t.to_s
              params[:"translations_#{n}"] = params[n]
              params.delete n
            end
          end
        end

        super(params, options)
      end
      alias :search :ransack unless respond_to? :search

      # preload translations
      def spree_base_scopes
        locales = translation_class.select('DISTINCT locale').order(:locale).map(&:locale)
        # Avoid using "IN" with SQL queries when only using one locale.
        locales = locales.first if locales.one?
          
        super.preload(:translations).joins(:translations).readonly(false).merge(translation_class.where(locale: locales)).tap do |query|
          query.distinct! unless locales.flatten.one?
        end
      end
    end
  end
end
