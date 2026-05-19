# spec/requests/application_controller_spec.rb
require 'rails_helper'

RSpec.describe "ApplicationController#set_cart", type: :request do
  include Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers

  let(:product) do
    create(:product, title: "Spec Product", price: 5.0, stock: 5)
  end

  it "creates a new cart for a guest and stores it (guest cart exists)" do
    expect {
      get root_path
    }.to change { Cart.count }.by(1)

    cart = Cart.order(:created_at).last
    expect(cart.user_id).to be_nil
  end

  context "when handling an existing guest cart session" do
    let(:user) { create(:user, email: "migrate@example.com") }
    let!(:guest_cart) { create(:cart) }
    let!(:cart_item) { create(:cart_item, cart: guest_cart, product: product, quantity: 2) }

    before do
      # Dynamically inject the session parameter into the controller instance
      # right as it processes the request, keeping Devise authentication fully intact.
      allow_any_instance_of(ApplicationController).to receive(:session).and_wrap_original do |original_method, *args|
        session_hash = original_method.call(*args)
        session_hash[:cart_id] = guest_cart.id
        session_hash
      end
      
      login_as(user, scope: :user)
    end

    it "migrates guest cart items to the current_user's cart upon login" do
      get root_path

      user.reload

      expect(user.cart).to be_present
      expect(user.cart.cart_items.sum(:quantity)).to eq(2)
    end

    it "destroys the old guest cart and clears session data after merge" do
      get root_path

      expect(Cart.find_by(id: guest_cart.id)).to be_nil
    end
  end
end