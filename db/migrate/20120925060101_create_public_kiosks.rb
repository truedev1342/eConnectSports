class CreatePublicKiosks < ActiveRecord::Migration[5.2]
  def change
    create_table :public_kiosks do |t|
      t.references :team
      t.string :background
      t.boolean :background_tile
      t.string :logo

      t.timestamps
    end
    unless index_exists?(:public_kiosks, :team_id)
      add_index :public_kiosks, :team_id
    end
  end
end
