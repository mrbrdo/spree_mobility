module SpreeMobility
  module Translatable
    extend ActiveSupport::Concern

    included do
      include Spree::TranslatableResource
      # define the i18n scope to prevent errors when classes are used
      # before 'translates' is called on the class - i18n scope is only created
      # upon calling translates.
      scope :i18n, -> { self } unless respond_to?(:i18n)
    end

    class_methods do
      def translation_class
        const_get('Translation')
      end

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
