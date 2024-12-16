class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.references :card
      t.string :name
      t.string :abbr
      t.string :value

      t.timestamps
    end
    add_index :stats, :card_id
  end
end
