class AddMessageToShares < ActiveRecord::Migration[7.2]
  def change
    add_column :shares, :message, :text
  end
end
