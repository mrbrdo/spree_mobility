class RemoveUnneededTranslations < ActiveRecord::Migration[4.2]
  def up
    drop_table :spree_state_translations
  end
end