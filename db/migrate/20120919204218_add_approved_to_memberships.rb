class AddApprovedToMemberships < ActiveRecord::Migration[7.2]
  def change
    add_column :memberships, :approved, :boolean
  end
end
