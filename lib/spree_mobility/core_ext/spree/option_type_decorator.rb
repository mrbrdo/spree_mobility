module SpreeMobility::CoreExt::Spree::OptionTypeDecorator
  def self.prepended(base)
    base.include SpreeMobility::Translatable
    SpreeMobility.translates_for base, *base::TRANSLATABLE_FIELDS

    base.translation_class.class_eval do
      validates :name, presence: true, uniqueness: { scope: :locale, case_sensitive: false, allow_blank: true }
    end
  end

  # Needed for admin
  def json_api_columns
    super + ['name', 'presentation']
  end
end
