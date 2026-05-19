class AddThumbnailToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :thumbnail, :string
  end
end
