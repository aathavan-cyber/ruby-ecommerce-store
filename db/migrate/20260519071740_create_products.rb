class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :category
      t.decimal :price
      t.decimal :discount_percentage
      t.decimal :rating
      t.integer :stock

      t.timestamps
    end
  end
end
