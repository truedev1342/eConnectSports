class AddCardIdToPublicPages < ActiveRecord::Migration[5.2]
  def change
    add_column :public_pages, :card_id, :integer
  end
end
