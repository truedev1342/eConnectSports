class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.references :user
      t.references :team

      t.timestamps
    end
    add_index :memberships, :user_id
    add_index :memberships, :team_id
  end
end
