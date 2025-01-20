class CreateStats < ActiveRecord::Migration[7.2]
  def change
    create_table :stats do |t|
      t.references :card
      t.string :name
      t.string :abbr
      t.string :value

      t.timestamps
    end
    unless index_exists?(:stats, :card_id)
      add_index :stats, :card_id
    end
  end
end
