class CreateCardPhones < ActiveRecord::Migration[5.2]
  def change
    create_table :card_phones do |t|
      t.string :nmbr
      t.integer :location
      t.references :card

      t.timestamps
    end
    add_index :card_phones, :card_id
  end
end
