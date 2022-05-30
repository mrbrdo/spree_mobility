class AddTranslationsToPaymentMethod < SpreeExtension::Migration[4.2]
  def up
    unless table_exists?(:spree_payment_method_translations)
      params = { name: :string, description: :text }
      create_translation_table(:spree_payment_method, params)
      migrate_data(Spree::PaymentMethod, params)
    end
  end

  def down
    drop_table :spree_payment_method_translations
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
