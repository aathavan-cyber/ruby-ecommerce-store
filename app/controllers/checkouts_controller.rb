# app/controllers/checkouts_controller.rb
class CheckoutsController < ApplicationController
  before_action :authenticate_user! # Require login to checkout

  def new
    @cart = @current_cart
    if @cart.nil? || @cart.cart_items.empty?
      redirect_to products_path, alert: "Your cart is empty!"
    end
  end

  def create
    @cart = @current_cart 
    payment_method = params[:payment_method] # 'credit_card' or 'upi'
    
    # 💳 1. CREDIT CARD VALIDATION FLOW
    if payment_method == "credit_card"
      # Strip out any spaces the user typed (e.g., "1234 5678 1234 5678" becomes "1234567812345678")
      card_number = params[:card_number].to_s.gsub(/\s+/, "")

      if card_number.blank?
        flash.now[:alert] = "Credit Card details cannot be blank."
        render :new, status: :unprocessable_entity and return
      elsif card_number.length != 16 || card_number.match?(/\D/)
        # Checks if length is NOT 16, or if it contains any non-digit characters (\D)
        flash.now[:alert] = "Invalid Credit Card number. It must be exactly 16 digits long."
        render :new, status: :unprocessable_entity and return
      end

    # 📱 2. UPI VALIDATION FLOW
    elsif payment_method == "upi"
      if params[:upi_id].blank?
        flash.now[:alert] = "UPI ID cannot be blank."
        render :new, status: :unprocessable_entity and return
      elsif !params[:upi_id].to_s.include?("@")
        flash.now[:alert] = "Invalid UPI ID. It must include an '@' symbol."
        render :new, status: :unprocessable_entity and return
      end
    end

    # 🚀 3. SUCCESS FLOOR (Executes only if validations above pass perfectly)
    if @cart
      @cart.cart_items.destroy_all
    end
    
    redirect_to products_path, notice: "Thank you! Order placed successfully via #{payment_method.upcase}."
  end
end