class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :first_name
      t.string :last_name
      t.string :position
      t.string :highlights
      t.string :team_name
      t.string :card_name
      t.references :user

      t.timestamps
    end
    add_index :cards, :user_id
  end
end
