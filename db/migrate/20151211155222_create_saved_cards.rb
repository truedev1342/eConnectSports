class CreateSavedCards < ActiveRecord::Migration
  def change
    create_table :saved_cards do |t|
      t.integer :user_id
      t.integer :card_id
 
      t.timestamps null: false
    end
  end
end
