class Cart < ApplicationRecord
  belongs_to :user, optional: true # optional allows guest carts if needed
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def total_items
    cart_items.sum(:quantity)
  end

  def total_price
    cart_items.to_a.sum { |item| item.product.price * item.quantity }
  end
end