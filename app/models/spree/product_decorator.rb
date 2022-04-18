module Spree
  module ProductDecorator
    class ProductTranslationQuery
      attr_reader :model, :search_attribute

      def initialize(model, search_attribute)
        @model = model
        @search_attribute = search_attribute
      end

      def add_joins(search_scope)
        fallback_locales.each do |locale|
          search_scope =
            model.mobility_backend_class(@search_attribute).
            send(:join_translations, search_scope, locale, Arel::Nodes::OuterJoin)
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
        model.mobility_backend_class(@search_attribute).table_alias(locale)
      end

      # Alternative method, not in use
      def search_with_case_subquery(scope, query)
        locale_int_cases = []
        int_locale_cases = []

        fallback_locales.each_with_index do |locale, idx|
          locale_int_cases << "WHEN #{model.translation_class.table_name}.locale = '#{locale}' THEN #{idx + 1}"
          int_locale_cases << "WHEN translation_score.highest_priority = #{idx + 1} THEN '#{locale}'"
        end

        locale_int = "(CASE #{locale_int_cases.join(' ')} ELSE NULL END)"
        int_locale = "(CASE #{int_locale_cases.join(' ')} ELSE NULL END)"
        names_subquery =
          model.translation_class.where.not(name: nil).
          select("spree_product_id, MIN(#{locale_int}) as highest_priority").
          group(:spree_product_id)

        scope.joins("INNER JOIN (#{names_subquery.to_sql}) AS translation_score ON translation_score.spree_product_id = spree_products.id INNER JOIN #{model.translation_class.table_name} ON #{model.translation_class.table_name}.spree_product_id = spree_products.id AND #{model.translation_class.table_name}.locale = #{int_locale}").
        order(:name).where("LOWER(#{model.translation_class.table_name}.name) LIKE LOWER(:query)", query: "%#{query}%")
      end
    end

    module ClassMethods
      def search_by_name(query)
        helper = ProductTranslationQuery.new(all.model, :name)

        helper.add_joins(self.all).
        where("LOWER(#{helper.col_name(:name)}) LIKE LOWER(:query)", query: "%#{query}%").distinct
      end
    
      def search_by_name_or_sku(query)
        helper = ProductTranslationQuery.new(all.model, :name)

        helper.add_joins(self.all).
        joins(:variants_including_master).
        where("(LOWER(#{helper.col_name(:name)}) LIKE LOWER(:query)) OR (LOWER(#{Spree::Variant.table_name}.sku) LIKE LOWER(:query))", query: "%#{query}%").distinct
      end

      def like_any(fields, values)
        mobility_fields = fields.select { |field| mobility_attributes.include?(field.to_s) }
        other_fields = fields - mobility_fields

        helper = ProductTranslationQuery.new(all.model, :name)
        conditions = mobility_fields.product(values).map do |(field, value)|
          sanitize_sql_array(["LOWER(#{helper.col_name(field)}) LIKE LOWER(?)", "%#{value}%"])
        end

        scope = other_fields.empty? ? self.all : super(other_fields, values)

        helper.add_joins(scope).where(conditions.join(' OR '))
      end
    end

    def self.prepended(base)
      SpreeMobility.translates_for base, :name, :description, :meta_title, :meta_description, :meta_keywords, :slug
      base.friendly_id :slug_candidates, use: [:history, :mobility]
      base.whitelisted_ransackable_scopes << 'search_by_name_or_sku'
  
      base.translation_class.class_eval do
        acts_as_paranoid
        after_destroy :punch_slug
        default_scopes = []
        validates :slug, presence: true, uniqueness: { scope: :locale, case_sensitive: false }

        with_options length: { maximum: 255 }, allow_blank: true do
          validates :meta_keywords
          validates :meta_title
        end
        with_options presence: true do
          validates :name
        end
      end

      if RUBY_VERSION.to_f >= 2.5
        base.translation_class.define_method(:punch_slug) { update(slug: "#{Time.current.to_i}_#{slug}"[0..254]) }
      else
        base.translation_class.send(:define_method, :punch_slug) { update(slug: "#{Time.current.to_i}_#{slug}"[0..254]) }
      end
    end

    Spree::Product.include SpreeMobility::Translatable

    # Don't punch slug on original product as it prevents bulk deletion.
    # Also we don't need it, as it is translated.
    def punch_slug; end

    def duplicate_extra(old_product)
      duplicate_translations(old_product)
    end

    def property(property_name)
      product_properties.joins(:property).find_by(spree_properties: { id: Spree::Property.find_by(name: property_name) }).try(:value)
    end

    private

    def duplicate_translations(old_product)
      self.translations.clear
      old_product.translations.each do |translation|
        translation.slug = nil # slug must be regenerated
        translation.name = "COPY OF #{translation.name}" unless translation.name&.start_with?('COPY OF ')
        self.translations << translation.dup
      end
    end
  end
end

SpreeMobility.prepend_once(::Spree::Product, Spree::ProductDecorator)
SpreeMobility.prepend_once(::Spree::Product.singleton_class, Spree::ProductDecorator::ClassMethods)
