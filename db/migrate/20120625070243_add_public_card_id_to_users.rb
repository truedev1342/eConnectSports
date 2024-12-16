class AddPublicCardIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :public_card_id, :integer
  end
end
