class AddContactCardToShares < ActiveRecord::Migration
  def change
    add_column :shares, :contact_card, :integer
  end
end
