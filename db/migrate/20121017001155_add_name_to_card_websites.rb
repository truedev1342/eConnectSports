class AddNameToCardWebsites < ActiveRecord::Migration
  def change
    add_column :card_websites, :name, :string
  end
end
