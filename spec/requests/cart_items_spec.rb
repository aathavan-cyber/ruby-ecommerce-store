require 'rails_helper'

RSpec.describe "CartItems", type: :request do
  include Devise::Test::IntegrationHelpers

    let(:user) { create(:user, email: "cartitems@example.com") }
    let(:product) { create(:product, title: "CartItem Test Product", price: 49.99) }

  describe "POST /cart_items" do
    it "adds a product to the cart" do
      sign_in user
        cart = create(:cart, user: user)

      post cart_items_path, params: { product_id: product.id }

      expect(cart.reload.cart_items.count).to eq(1)
      expect(cart.cart_items.first.quantity).to eq(1)
    end
  end

  describe "PATCH /cart_items/:id" do
    it "updates the quantity of a cart item" do
      sign_in user
        cart = create(:cart, user: user)
        cart_item = create(:cart_item, cart: cart, product: product, quantity: 1)

      patch cart_item_path(cart_item), params: { cart_item: { quantity: 5 } }, headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(cart_item.reload.quantity).to eq(5)
    end
  end

  describe "DELETE /cart_items/:id" do
    it "removes a cart item" do
      sign_in user
        cart = create(:cart, user: user)
        cart_item = create(:cart_item, cart: cart, product: product, quantity: 1)

      delete cart_item_path(cart_item), headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(CartItem.exists?(cart_item.id)).to be false
    end
  end
end
