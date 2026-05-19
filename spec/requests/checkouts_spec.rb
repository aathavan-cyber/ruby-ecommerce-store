require 'rails_helper'

RSpec.describe "Checkouts", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) do
    User.create!(email: "test@example.com", password: "password")
  end

  let(:product) do
    Product.create!(
      title: "Sample Product",
      description: "A test product",
      category: "Test",
      price: 10.0,
      discount_percentage: 0.0,
      rating: 0.0,
      stock: 10,
      thumbnail: "sample.jpg"
    )
  end

  let(:cart) { Cart.create!(user: user) }
  let!(:cart_item) { CartItem.create!(cart: cart, product: product, quantity: 1) }

  before do
    sign_in user
  end

  describe "POST /checkout" do
    context "credit card - valid 16 digits" do
      it "places the order successfully and clears the cart" do
        post checkout_path, params: {
          payment_method: "credit_card",
          card_number: "1234567812345678"
        }

        expect(response).to redirect_to(products_path)
        expect(flash[:notice]).to eq("Thank you! Order placed successfully via CREDIT_CARD.")
        expect(cart.reload.cart_items.count).to eq(0)
      end
    end

    context "credit card - with spaces" do
      it "accepts spaced card number and succeeds" do
        post checkout_path, params: {
          payment_method: "credit_card",
          card_number: "1234 5678 1234 5678"
        }

        expect(response).to redirect_to(products_path)
        expect(flash[:notice]).to eq("Thank you! Order placed successfully via CREDIT_CARD.")
        expect(cart.reload.cart_items.count).to eq(0)
      end
    end

    context "credit card - invalid 15 digits" do
      it "returns 422 and does not clear the cart" do
        post checkout_path, params: {
          payment_method: "credit_card",
          card_number: "123456781234567"
        }

        expect(response).to have_http_status(422)
        expect(flash[:alert]).to eq("Invalid Credit Card number. It must be exactly 16 digits long.")
        expect(cart.reload.cart_items.count).to eq(1)
      end
    end

    context "UPI - valid" do
      it "places the order successfully and clears the cart" do
        post checkout_path, params: {
          payment_method: "upi",
          upi_id: "user@bank"
        }

        expect(response).to redirect_to(products_path)
        expect(flash[:notice]).to eq("Thank you! Order placed successfully via UPI.")
        expect(cart.reload.cart_items.count).to eq(0)
      end
    end

    context "UPI - missing @" do
      it "returns 422 and does not clear the cart" do
        post checkout_path, params: {
          payment_method: "upi",
          upi_id: "invalidupi"
        }

        expect(response).to have_http_status(422)
        expect(flash[:alert]).to eq("Invalid UPI ID. It must include an '@' symbol.")
        expect(cart.reload.cart_items.count).to eq(1)
      end
    end
  end
end
