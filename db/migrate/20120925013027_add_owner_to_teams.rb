class AddOwnerToTeams < ActiveRecord::Migration[7.2]
  def change
    add_column :teams, :owner_id, :integer
  end
end
