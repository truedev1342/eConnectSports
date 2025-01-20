class AddCardsPurchasedToPayments < ActiveRecord::Migration[7.2]
  def change
    add_column :payments, :cards_purchased, :integer
  end
end
