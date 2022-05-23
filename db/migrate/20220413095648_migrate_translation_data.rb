class MigrateTranslationData < SpreeExtension::Migration[4.2]
  def up
    create_helper Spree::Product, { name: :string, description: :text, meta_title: :string,
               meta_description: :string, meta_keywords: :string, slug: :string, deleted_at: :datetime }

    create_helper Spree::Promotion, { name: :string, description: :string }

    create_helper Spree::OptionType, { name: :string, presentation: :string }

    create_helper Spree::Property, { name: :string, presentation: :string }

    create_helper Spree::Taxonomy, { name: :string }

    create_helper Spree::Taxon, { name: :string, description: :text, meta_title: :string,
               meta_description: :string, meta_keywords: :string,
               permalink: :string }

    create_helper Spree::OptionValue, { name: :string, presentation: :string }

    create_helper Spree::ProductProperty, { value: :string }

    create_helper Spree::Store, { name: :string, meta_description: :text, meta_keywords: :text, seo_title: :string }

    create_helper Spree::ShippingMethod, { name: :string }
  end

  def down
    # no need to do anything
  end

  protected

  def create_helper(model_klass, fields)
    store = Spree::Store.unscoped.first
    return unless store
    default_locale = (store.default_locale || :en).to_s
    field_names = fields.keys + ['created_at', 'updated_at']
    translation_table = "#{model_klass.table_name.singularize}_translations"
    foreign_key = "#{model_klass.table_name.singularize}_id"

    # In case we are migrating from Globalize with existing translations, skip this step
    return if ActiveRecord::Base.connection.execute("SELECT id FROM #{translation_table}").any?
    ActiveRecord::Base.connection.execute("SELECT id, #{field_names.join(',')} FROM #{model_klass.table_name}").each do |r|
      field_values =
        field_names.each_with_object([]) do |field_name, a|
          a << r[field_name.to_s]
        end

      ActiveRecord::Base.connection.execute(ActiveRecord::Base.sanitize_sql_array(["INSERT INTO #{translation_table} (locale, #{foreign_key}, #{field_names.join(',')}) VALUES (?,?,#{(['?'] * field_names.size).join(',')})",
        default_locale.to_s, r['id'], *field_values]))
    end
  end
end
