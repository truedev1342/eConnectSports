class AddUserIdToPayments < ActiveRecord::Migration[7.2]
  def change
    add_column :payments, :user_id, :integer
  end
end
