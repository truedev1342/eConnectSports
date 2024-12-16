class AddCardsPurchasedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cards_purchased, :integer
  end
end
