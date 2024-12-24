class AddOwnerToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :owner_id, :integer
  end
end
