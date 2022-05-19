module SpreeMobility
  module Translatable
    extend ActiveSupport::Concern

    include Spree::RansackableAttributes

    included do |klass|
      klass.send :extend, Mobility
      # define the i18n scope to prevent errors when classes are used
      # before 'translates' is called on the class - i18n scope is only created
      # upon calling translates.
      klass.scope :i18n, -> { self }
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

      module CopyPreloadedActiveTranslationsToTranslations
        # Although it has :nodoc, preload_associations is a public method of
        # ActiveRecord::Relation and should be relatively safe to use.
        # After the active_translations assoc is preloaded, we copy results over
        # into translations - basically we load translations with results from
        # active_translations.
        def preload_associations(records)
          super.tap do
            records.each do |record|
              # We don't want to overwrite translations if already present
              next if record.association(:translations).target.present?
              record.association(:translations).target =
                record.association(:active_translations).target
            end
          end
        end
      end

      def spree_base_scopes
        # Only preload translations for current locale and its fallbacks
        scope = super.preload(:active_translations)
        scope.singleton_class.prepend CopyPreloadedActiveTranslationsToTranslations
        return scope
      end
    end
  end
end
