class AddApprovedToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :approved, :boolean
  end
end
