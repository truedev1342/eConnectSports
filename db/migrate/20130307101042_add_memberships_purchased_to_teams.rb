class AddMembershipsPurchasedToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :memberships_purchased, :integer
  end
end
