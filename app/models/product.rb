class Product < ApplicationRecord
  validates :title, :price, :stock, presence: true
end