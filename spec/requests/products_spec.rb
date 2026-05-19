require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:product) { create(:product, title: "Electronics Product", price: 199.99, stock: 50) }

  describe "GET /products" do
    it "returns all products" do
      product
      get products_path
      
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.title)
    end
  end

  describe "GET /products/:id" do
    it "returns a specific product" do
      get product_path(product)
      
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.title)
    end

    it "returns 404 for non-existent product" do
      get product_path(id: 99999)
      
      expect(response).to have_http_status(:not_found)
    end
  end
end
