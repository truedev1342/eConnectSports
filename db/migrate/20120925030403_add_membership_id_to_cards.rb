class AddMembershipIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :membership_id, :integer
  end
end
