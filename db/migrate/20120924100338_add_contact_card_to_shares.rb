class AddContactCardToShares < ActiveRecord::Migration[5.2]
  def change
    add_column :shares, :contact_card, :integer
  end
end
