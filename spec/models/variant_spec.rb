require 'spec_helper'

module Spree
  RSpec.describe Variant do
    let(:product) do
      Product.create!(
        name: 'mobility',
        price: 19.99,
        shipping_category: ShippingCategory.create!(name: 'a')
      )
    end

    let!(:variant) do
      Variant.create!(
        price: 19.99,
        product: product
      )
    end

    # this test is invalid, should be removed or changed
    #  see https://github.com/spree-contrib/spree_mobility/commit/87802a97c8ee82f5444243467faf2a8faa8236f6#commitcomment-12963401
    xit 'fetches variant from product via translation table' do
      product_relation = Product.where(name: "mobility")
      variant_relation = described_class.joins(:product).merge(product_relation)
      described_class.includes(:product).ransack(name_cont: 'mobility').result.to_a

      expect(variant_relation.last).to eq variant

      variants = described_class.includes(:product).ransack(name_cont: 'mobility').result.to_a
      expect(variants.last).to eq variant
    end
  end
end
