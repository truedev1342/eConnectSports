class AddMembershipsPurchasedToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :memberships_purchased, :integer
  end
end
