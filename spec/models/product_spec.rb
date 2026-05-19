require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it 'has many cart_items' do
      assoc = described_class.reflect_on_association(:cart_items)
      expect(assoc).not_to be_nil
      expect(assoc.macro).to eq(:has_many)
    end

    it 'has many carts through cart_items' do
      assoc = described_class.reflect_on_association(:carts)
      expect(assoc).not_to be_nil
      expect(assoc.macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    it 'is valid with all required attributes' do
      product = build(:product)
      expect(product).to be_valid
    end
  end
end
