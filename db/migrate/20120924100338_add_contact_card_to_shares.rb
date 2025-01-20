class AddContactCardToShares < ActiveRecord::Migration[7.2]
  def change
    add_column :shares, :contact_card, :integer
  end
end
