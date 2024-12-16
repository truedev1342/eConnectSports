class CreateCardEmails < ActiveRecord::Migration
  def change
    create_table :card_emails do |t|
      t.string :address
      t.references :card

      t.timestamps
    end
    add_index :card_emails, :card_id
  end
end
