class CreateActivities < ActiveRecord::Migration[5.2]
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
    unless index_exists?(:activities, :user_id)
      add_index :activities, :user_id
    end
  end
end
