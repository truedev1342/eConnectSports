class CreateMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :memberships do |t|
      t.references :user
      t.references :team

      t.timestamps
    end
    
    unless index_exists?(:memberships, :user_id)
      add_index :memberships, :user_id
    end

    unless index_exists?(:memberships, :team_id)
      add_index :memberships, :team_id
    end
    
  end
end
