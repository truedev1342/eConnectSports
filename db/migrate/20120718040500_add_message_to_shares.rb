class AddMessageToShares < ActiveRecord::Migration
  def change
    add_column :shares, :message, :text
  end
end
