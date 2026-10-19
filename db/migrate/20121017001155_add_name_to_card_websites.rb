class AddNameToCardWebsites < ActiveRecord::Migration[7.2]
  def change
    add_column :card_websites, :name, :string
  end
end
