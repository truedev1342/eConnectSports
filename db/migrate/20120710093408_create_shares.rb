class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.belongs_to :shareable, polymorphic: true
      t.integer :user_id
      t.string :destination_email

      t.timestamps
    end
  end
end