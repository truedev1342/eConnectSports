class AddMembershipIdToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :membership_id, :integer
  end
end
