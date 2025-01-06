class CreateCardWebsites < ActiveRecord::Migration[7.2]
  def change
    create_table :card_websites do |t|
      t.string :url
      t.references :card

      t.timestamps
    end
    unless index_exists?(:card_websites, :card_id)
      add_index :card_websites, :card_id
    end
  end
end
