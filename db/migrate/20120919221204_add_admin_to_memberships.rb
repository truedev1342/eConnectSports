class AddAdminToMemberships < ActiveRecord::Migration[7.2]
  def change
    add_column :memberships, :admin, :boolean
  end
end
