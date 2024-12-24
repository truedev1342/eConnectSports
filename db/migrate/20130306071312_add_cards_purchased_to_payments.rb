class AddCardsPurchasedToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :cards_purchased, :integer
  end
end
