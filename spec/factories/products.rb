FactoryBot.define do
  factory :product do
    sequence(:title) { |n| "Product #{n}" }
    description { "A test product" }
    category { "Test" }
    price { 9.99 }
    discount_percentage { 0.0 }
    rating { 0.0 }
    stock { 10 }
    thumbnail { "product.jpg" }
  end
end
