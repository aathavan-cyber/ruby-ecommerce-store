require 'rails_helper'

RSpec.describe "Carts", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user, email: "cart@example.com") }
  let(:product) { create(:product, title: "Cart Test Product", price: 29.99) }

  describe "GET /carts/:id" do
    it "displays the cart for a signed-in user" do
      sign_in user
      cart = user.create_cart!
      CartItem.create!(cart: cart, product: product, quantity: 2)

      get cart_path(cart)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.title)
    end
  end
end
