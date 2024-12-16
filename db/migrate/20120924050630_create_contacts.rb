class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :user
      t.references :card

      t.timestamps
    end
    add_index :contacts, :user_id
    add_index :contacts, :card_id
  end
end
