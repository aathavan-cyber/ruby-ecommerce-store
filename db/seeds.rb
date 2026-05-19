# db/seeds.rb
require 'json'

file = File.read(Rails.root.join('db', 'seeds.json'))
data = JSON.parse(file)

data['products'].each do |p|
  Product.find_or_create_by!(id: p['id']) do |product|
    product.title = p['title']
    product.description = p['description']
    product.category = p['category']
    product.price = p['price']
    product.discount_percentage = p['discountPercentage']
    product.rating = p['rating']
    product.stock = p['stock']
    product.thumbnail = p['thumbnail'] # Add this line
  end
end

puts "Seeded #{Product.count} products (without tags) successfully!"