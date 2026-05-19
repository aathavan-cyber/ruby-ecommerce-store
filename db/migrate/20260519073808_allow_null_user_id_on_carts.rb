class AllowNullUserIdOnCarts < ActiveRecord::Migration[7.1]
  def change
    # not null
    change_column_null :carts, :user_id, true
  end
end