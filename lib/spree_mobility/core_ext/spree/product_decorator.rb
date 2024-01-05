module SpreeMobility::CoreExt::Spree
  module ProductDecorator
    module ClassMethods
      def search_by_name(query)
        like_any([:name], [query]).distinct
      end

      def like_any(fields, values)
        mobility_fields = fields.select { |field| mobility_attributes.include?(field.to_s) }
        other_fields = fields - mobility_fields

        helper = SpreeMobility::TranslationQuery.new(all.model.mobility_backend_class(:name))
        conditions = mobility_fields.product(values).map do |(field, value)|
          sanitize_sql_array(["LOWER(#{helper.col_name(field)}) LIKE ?", "%#{value&.downcase}%"])
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
      SpreeMobility.translates_for base, *base::TRANSLATABLE_FIELDS

      base.translation_class.class_eval do
        extend FriendlyId
        friendly_id :name, use: :slugged
        before_validation :downcase_slug
        before_validation :normalize_slug, on: :update

        def normalize_slug
          self.slug = normalize_friendly_id(slug)
        end

        def downcase_slug
          slug&.downcase!
        end

        acts_as_paranoid unless included_modules.include?(Paranoia)
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

      base.translation_class.define_method(:punch_slug) { update(slug: "#{Time.current.to_i}_#{slug}"[0..254]) }
    end

    # Don't punch slug on original product as it prevents bulk deletion.
    # Also we don't need it, as it is translated.
    def punch_slug; end

    def duplicate_extra(old_product)
      duplicate_translations(old_product)
    end

    private

    def duplicate_translations(old_product)
      # Spree 4.6.0 does some of this, but not all
      self.translations.clear
      old_product.translations.each do |translation|
        translation.slug = nil # slug must be regenerated
        translation.name = "COPY OF #{translation.name}" unless translation.name&.start_with?('COPY OF ')
        self.translations << translation.dup
      end
    end
  end
end
