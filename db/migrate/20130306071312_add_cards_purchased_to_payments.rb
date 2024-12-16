class AddCardsPurchasedToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :cards_purchased, :integer
  end
end
