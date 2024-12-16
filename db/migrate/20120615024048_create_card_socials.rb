class CreateCardSocials < ActiveRecord::Migration
  def change
    create_table :card_socials do |t|
      t.string :url
      t.integer :kind
      t.references :card

      t.timestamps
    end
    add_index :card_socials, :card_id
  end
end
