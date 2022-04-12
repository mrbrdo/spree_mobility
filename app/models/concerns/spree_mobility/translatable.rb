module SpreeMobility
  module Translatable
    extend ActiveSupport::Concern

    include Spree::RansackableAttributes

    included do |klass|
      klass.send :extend, Mobility
      klass.send(:default_scope) { i18n }
      has_many :translations
      accepts_nested_attributes_for :translations
      klass.whitelisted_ransackable_associations ||= []
      klass.whitelisted_ransackable_associations |= ['translations']
    end

    class_methods do
      def translation_class
        const_get('Translation')
      end
      
      def ransack(params = {}, options = {})
        params ||= {}
        names = params.keys
        params[:translations_locale_eq] ||= I18n.locale.to_s

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
