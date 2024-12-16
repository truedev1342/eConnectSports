class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user
      t.string :note
      t.string :browser
      t.string :ip_address
      t.string :controller
      t.string :action
      t.text :params

      t.timestamps
    end
    add_index :activities, :user_id
  end
end
