class AddTranslationsToCountry < ActiveRecord::Migration[4.2]
  def up
    unless table_exists?(:spree_country_translations)
      params = { name: :string }
      create_translation_table(:spree_country, params)
      migrate_data(Spree::Country, params)
    end
  end

  protected

  def create_translation_table(table, params)
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

  def migrate_data(model_klass, fields)
    store = Spree::Store.unscoped.first
    return unless store
    default_locale = store.default_locale.to_s
    field_names = fields.keys | [:created_at, :updated_at]
    translation_table = "#{model_klass.table_name.singularize}_translations"
    foreign_key = "#{model_klass.table_name.singularize}_id"

    # In case we are migrating from Globalize with existing translations, skip this step
    return if ActiveRecord::Base.connection.execute("SELECT id FROM #{translation_table}").any?
    ActiveRecord::Base.connection.execute("SELECT id, #{field_names.join(',')} FROM #{model_klass.table_name}").each do |r|
      field_values =
        field_names.map do |field_name|
          if field_name.in?([:created_at, :updated_at])
            r[field_name.to_s] || Time.now.to_s(:db)
          else
            r[field_name.to_s]
          end
        end

      ActiveRecord::Base.connection.execute(ActiveRecord::Base.sanitize_sql_array(["INSERT INTO #{translation_table} (locale, #{foreign_key}, #{field_names.join(',')}) VALUES (?,?,#{(['?'] * field_names.size).join(',')})",
        default_locale.to_s, r['id'], *field_values]))
    end
  end
end
