module Spree::StoreDecorator
  def self.prepended(base)
    if ::ApplicationRecord.connected? && ::ApplicationRecord.connection.table_exists?(:spree_store_translations)
      SpreeMobility.translates_for base, :name, :meta_description, :meta_keywords, :seo_title
      
      base.translation_class.class_eval do
        validates :name, presence: true
      end
    end
  end

  Spree::Store.include SpreeMobility::Translatable
end

SpreeMobility.prepend_once(::Spree::Store, Spree::StoreDecorator)