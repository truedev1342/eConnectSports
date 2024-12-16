class AddFieldsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :card_id, :integer
    add_column :payments, :paid_to, :datetime
    add_column :payments, :parent_id, :integer
    add_column :payments, :period, :integer, default: 8
  end
end
