class CreateCardEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :card_emails do |t|
      t.string :address
      t.references :card

      t.timestamps
    end
    unless index_exists?(:card_emails, :card_id)
      add_index :card_emails, :card_id
    end
  end
end
