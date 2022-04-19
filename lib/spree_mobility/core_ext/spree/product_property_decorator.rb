module SpreeMobility::CoreExt::Spree::ProductPropertyDecorator
  def self.prepended(base)
    base.include SpreeMobility::Translatable
    SpreeMobility.translates_for base, :value
  end
end
