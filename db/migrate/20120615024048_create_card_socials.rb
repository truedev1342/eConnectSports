class CreateCardSocials < ActiveRecord::Migration[5.2]
  def change
    create_table :card_socials do |t|
      t.string :url
      t.integer :kind
      t.references :card

      t.timestamps
    end
    unless index_exists?(:card_socials, :card_id)
      add_index :card_socials, :card_id
    end
  end
end
