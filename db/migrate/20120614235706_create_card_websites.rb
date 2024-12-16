class CreateCardWebsites < ActiveRecord::Migration
  def change
    create_table :card_websites do |t|
      t.string :url
      t.references :card

      t.timestamps
    end
    add_index :card_websites, :card_id
  end
end
