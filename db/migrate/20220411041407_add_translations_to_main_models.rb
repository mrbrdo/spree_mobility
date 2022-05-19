class AddTranslationsToMainModels < SpreeExtension::Migration[4.2]
  def up
    unless table_exists?(:spree_product_translations)
      create_helper :spree_product, { name: :string, description: :text, meta_title: :string,
                 meta_description: :string, meta_keywords: :string, slug: :string, deleted_at: :datetime }
      add_index :spree_product_translations, :deleted_at
    end

    unless table_exists?(:spree_promotion_translations)
      create_helper :spree_promotion, { name: :string, description: :string }
    end

    unless table_exists?(:spree_option_type_translations)
      create_helper :spree_option_type, { name: :string, presentation: :string }
    end

    unless table_exists?(:spree_property_translations)
      create_helper :spree_property, { name: :string, presentation: :string }
    end

    unless table_exists?(:spree_taxonomy_translations)
      create_helper :spree_taxonomy, { name: :string }
    end

    unless table_exists?(:spree_taxon_translations)
      create_helper :spree_taxon, { name: :string, description: :text, meta_title: :string,
                 meta_description: :string, meta_keywords: :string,
                 permalink: :string }
    end

    unless table_exists?(:spree_option_value_translations)
      create_helper :spree_option_value, { name: :string, presentation: :string }
    end

    unless table_exists?(:spree_product_property_translations)
      create_helper :spree_product_property, { value: :string }
    end

    unless table_exists?(:spree_store_translations)
      create_helper :spree_store, { name: :string, meta_description: :text, meta_keywords: :text, seo_title: :string }
    end

    unless table_exists?(:spree_shipping_method_translations)
      create_helper :spree_shipping_method, { name: :string }
    end

    unless column_exists?(:friendly_id_slugs, :locale)
      add_column :friendly_id_slugs, :locale, :string
    end
  end

  def down
    drop_table :spree_product_translations
    drop_table :spree_promotion_translations
    drop_table :spree_option_type_translations
    drop_table :spree_property_translations
    drop_table :spree_taxonomy_translations
    drop_table :spree_taxon_translations
    drop_table :spree_option_value_translations
    drop_table :spree_product_property_translations
    drop_table :spree_store_translations
    drop_table :spree_shipping_method_translations
    remove_column :friendly_id_slugs, :locale
  end

  protected

  def create_helper(table, params)
    create_table :"#{table}_translations" do |t|

      # Translated attribute(s)
      params.each_pair do |attr, attr_type|
        t.send attr_type, attr
      end

      t.string  :locale, null: false
      t.references table, null: false, foreign_key: true, index: false

      t.timestamps null: false
    end

    add_index :"#{table}_translations", :locale, name: :"index_#{table}_translations_on_locale"
    add_index :"#{table}_translations", [:"#{table}_id", :locale], name: :"index_#{table}_translations_on_id_and_locale", unique: true
  end
end
