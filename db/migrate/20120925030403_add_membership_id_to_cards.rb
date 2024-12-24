class AddMembershipIdToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :membership_id, :integer
  end
end
