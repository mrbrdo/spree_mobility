module SpreeMobility
  module CoreExt
    module Spree
      module StoreDecorator
        def self.prepended(base)
          base.include SpreeMobility::Translatable
          SpreeMobility.translates_for base, *base::TRANSLATABLE_FIELDS

          base.translation_class.class_eval do
            validates :name, presence: true
          end
        end
      end
    end
  end
end