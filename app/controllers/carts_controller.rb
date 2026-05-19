# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  def show
    # @current_cart is already defined by the before_action in ApplicationController!
    @cart = @current_cart
  end
end