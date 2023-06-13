module SpreeMobility::CoreExt::Spree::ProductPropertyDecorator
  def self.prepended(base)
    base.include SpreeMobility::Translatable
    SpreeMobility.translates_for base, *base::TRANSLATABLE_FIELDS
  end
end
