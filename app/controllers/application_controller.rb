# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :set_cart

  private

  def set_cart
    if user_signed_in?
      # 1. Grab or create the user's permanent database cart
      user_cart = current_user.cart || current_user.create_cart
      
      # 2. Check if they have an active guest cart floating around in their session
      if session[:cart_id].present?
        guest_cart = Cart.find_by(id: session[:cart_id])
        
        # 3. If a guest cart exists and it isn't already the user's cart, merge them!
        if guest_cart && guest_cart != user_cart
          guest_cart.cart_items.each do |item|
            # Look for an identical item in the user's permanent cart
            existing_item = user_cart.cart_items.find_by(product_id: item.product_id)
            
            if existing_item
              # If they already had it, combine the quantities
              existing_item.update(quantity: existing_item.quantity + item.quantity)
              item.destroy # Delete the duplicate guest item record
            else
              # Otherwise, transfer ownership of the item directly to the user's cart
              item.update(cart_id: user_cart.id)
            end
          end
          
          # CRITICAL: Force ActiveRecord to refresh its collection memory from the database 
          # so it recognizes the newly migrated items before the guest cart structure changes.
          user_cart.cart_items.reload
          
          # CRITICAL: Use .delete instead of .destroy. This cleans up the empty guest cart 
          # row from the database without triggering dependent model callbacks that could 
          # accidentally target the items we just transferred.
          guest_cart.delete
        end
        
        # Clear the guest session completely now that they are logged in
        session[:cart_id] = nil
      end

      @current_cart = user_cart
    else
      # Guest logic remains clean and self-contained
      @current_cart = Cart.find_by(id: session[:cart_id])
      if @current_cart.nil?
        @current_cart = Cart.create
        session[:cart_id] = @current_cart.id
      end
    end
  end
end