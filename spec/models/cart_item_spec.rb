require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'associations' do
    it 'belongs to a cart' do
      assoc = described_class.reflect_on_association(:cart)
      expect(assoc).not_to be_nil
      expect(assoc.macro).to eq(:belongs_to)
    end

    it 'belongs to a product' do
      assoc = described_class.reflect_on_association(:product)
      expect(assoc).not_to be_nil
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'validates quantity is >= 1' do
      ci = CartItem.new(quantity: 0)
      ci.validate
      expect(ci.errors[:quantity]).not_to be_empty
    end
  end
end
