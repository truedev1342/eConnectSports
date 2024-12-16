class CreatePublicKiosks < ActiveRecord::Migration
  def change
    create_table :public_kiosks do |t|
      t.references :team
      t.string :background
      t.boolean :background_tile
      t.string :logo

      t.timestamps
    end
    add_index :public_kiosks, :team_id
  end
end
