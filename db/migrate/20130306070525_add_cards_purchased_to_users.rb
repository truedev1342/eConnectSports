class AddCardsPurchasedToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :cards_purchased, :integer
  end
end
