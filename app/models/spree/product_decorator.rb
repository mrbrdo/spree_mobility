module Spree
  module ProductDecorator
    module ClassMethods
      def search_by_name(query)
        joins(:translations).order(:name).where("LOWER(#{Spree::Product::Translation.table_name}.name) LIKE LOWER(:query)", query: "%#{query}%").distinct
      end
      
      def like_any(fields, values)
        translations = Spree::Product::Translation.arel_table
        source = fields.product(values, [translations, arel_table])
        clauses = source.map do |(field, value, arel)|
          arel[field].matches("%#{value}%")
        end.inject(:or)
  
        joins(:translations).where(translations[:locale].eq(I18n.locale)).where(clauses)
      end
    end
    
    def self.prepended(base)
      base.translates :name, :description, :meta_title, :meta_description, :meta_keywords, :slug
      base.friendly_id :slug_candidates, use: [:history, :mobility]

      base.translation_class.acts_as_paranoid
      base.translation_class.after_destroy :punch_slug
      base.translation_class.default_scopes = []
      base.translation_class.validates :slug, presence: true, uniqueness: { case_sensitive: false }

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
