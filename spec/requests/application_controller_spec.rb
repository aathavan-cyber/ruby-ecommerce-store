require 'rails_helper'

RSpec.describe "ApplicationController#set_cart", type: :request do
  include Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers

  let(:product) do
    Product.create!(
      title: "Spec Product",
      description: "description",
      category: "spec",
      price: 5.0,
      discount_percentage: 0.0,
      rating: 0.0,
      stock: 5,
      thumbnail: "t.jpg"
    )
  end

  it "creates a new cart for a guest and stores it (guest cart exists)" do
    expect {
      get root_path
    }.to change { Cart.count }.by(1)

    cart = Cart.order(:created_at).last
    expect(cart.user_id).to be_nil
  end

  it "migrates guest cart items to the current_user's cart upon login" do
    guest_cart = Cart.create!
    CartItem.create!(cart: guest_cart, product: product, quantity: 2)

    user = User.create!(email: "migrate@example.com", password: "password")

    gid = guest_cart.id
    login_as(user, scope: :user)
    get root_path, env: { 'rack.session' => { cart_id: gid } }

    user.reload
    expect(user.cart).to be_present
    expect(user.cart.cart_items.sum(:quantity)).to eq(2)
  end

  it "destroys the old guest cart and clears session data after merge" do
    guest_cart = Cart.create!
    CartItem.create!(cart: guest_cart, product: product, quantity: 1)

    user = User.create!(email: "destroy@example.com", password: "password")

    gid = guest_cart.id
    login_as(user, scope: :user)
    get root_path, env: { 'rack.session' => { cart_id: gid } }

    expect(Cart.find_by(id: guest_cart.id)).to be_nil
  end
end
