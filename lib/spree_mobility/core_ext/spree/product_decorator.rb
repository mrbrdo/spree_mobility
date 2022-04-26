module SpreeMobility::CoreExt::Spree
  module ProductDecorator


    module ClassMethods
      def search_by_name(query)
        helper = SpreeMobility::TranslationQuery.new(all.model.mobility_backend_class(:name))

        helper.add_joins(self.all).
        where("LOWER(#{helper.col_name(:name)}) LIKE LOWER(:query)", query: "%#{query}%").distinct
      end
    
      def like_any(fields, values)
        mobility_fields = fields.select { |field| mobility_attributes.include?(field.to_s) }
        other_fields = fields - mobility_fields

        helper = SpreeMobility::TranslationQuery.new(all.model.mobility_backend_class(:name))
        conditions = mobility_fields.product(values).map do |(field, value)|
          sanitize_sql_array(["LOWER(#{helper.col_name(field)}) LIKE LOWER(?)", "%#{value}%"])
        end

        # From original like_any method
        conditions += other_fields.product(values).map do |(field, value)|
          arel_table[field].matches("%#{value}%").to_sql
        end
        
        # Allow further adding/modification of conditions
        conditions = yield(conditions) if block_given?

        helper.add_joins(self.all).where(conditions.join(' OR '))
      end
    end

    def self.prepended(base)
      base.include SpreeMobility::Translatable
      SpreeMobility.translates_for base, :name, :description, :meta_title, :meta_description, :meta_keywords, :slug
      base.friendly_id :slug_candidates, use: [:history, :mobility]
  
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

    # Don't punch slug on original product as it prevents bulk deletion.
    # Also we don't need it, as it is translated.
    def punch_slug; end

    def duplicate_extra(old_product)
      duplicate_translations(old_product)
    end

    def property(property_name)
      product_properties.joins(:property).find_by(spree_properties: { id: ::Spree::Property.find_by(name: property_name) }).try(:value)
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
