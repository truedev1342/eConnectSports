class AddCardIdToPublicPages < ActiveRecord::Migration
  def change
    add_column :public_pages, :card_id, :integer
  end
end
