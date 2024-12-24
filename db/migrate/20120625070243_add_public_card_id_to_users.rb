class AddPublicCardIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :public_card_id, :integer
  end
end
