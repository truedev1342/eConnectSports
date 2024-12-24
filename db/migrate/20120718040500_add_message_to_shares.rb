class AddMessageToShares < ActiveRecord::Migration[5.2]
  def change
    add_column :shares, :message, :text
  end
end
