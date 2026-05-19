class ProductsController < ApplicationController
  def index
    @products = Product.all
    if params[:search].present?
      @products = @products.where("title ILIKE ? OR description ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end
  end

  def show
    @product = Product.find(params[:id])
  end
end