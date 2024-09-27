module SpreeMobility
  module CoreExt
    module Spree
      module OptionTypeDecorator
        def self.prepended(base)
          base.include SpreeMobility::Translatable
          SpreeMobility.translates_for base, *base::TRANSLATABLE_FIELDS
        end
      end
    end
  end
end
