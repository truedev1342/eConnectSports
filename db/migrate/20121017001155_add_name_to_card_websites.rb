class AddNameToCardWebsites < ActiveRecord::Migration[5.2]
  def change
    add_column :card_websites, :name, :string
  end
end
