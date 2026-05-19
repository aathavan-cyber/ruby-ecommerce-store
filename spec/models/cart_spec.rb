require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it 'has many cart_items with dependent: :destroy' do
      assoc = described_class.reflect_on_association(:cart_items)
      expect(assoc).not_to be_nil
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end

    it 'belongs to user (optional)' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc).not_to be_nil
      expect(assoc.macro).to eq(:belongs_to)
      expect(assoc.options[:optional]).to be true
    end
  end

  describe 'dependent behavior' do
    it 'destroys associated cart_items when destroyed' do
      cart = Cart.create!
      product = Product.create!(
        title: "CartSpec Product",
        description: "desc",
        category: "spec",
        price: 1.0,
        discount_percentage: 0.0,
        rating: 0.0,
        stock: 1,
        thumbnail: "t.jpg"
      )

      cart_item = CartItem.create!(cart: cart, product: product, quantity: 1)

      expect(CartItem.exists?(cart_item.id)).to be true
      expect { cart.destroy }.to change { CartItem.exists?(cart_item.id) }.from(true).to(false)
    end
  end
end
