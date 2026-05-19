# app/controllers/cart_items_controller.rb
class CartItemsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    @cart_item = @current_cart.cart_items.find_or_initialize_by(product_id: product.id)
    @cart_item.quantity = (@cart_item.quantity || 0) + 1

    if @cart_item.save
      respond_to do |format|
        format.html { redirect_to products_path, notice: "Added to cart" }
        format.turbo_stream # This line tells Rails to look for create.turbo_stream.erb
      end
    end
  end
end