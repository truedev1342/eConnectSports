class CreateTeamPayments < ActiveRecord::Migration[7.2]
  def change
    create_table :team_payments do |t|
      t.string :status
      t.integer :amount
      t.string :email
      t.string :transaction_number
      t.string :stripe_customer_token
      t.references :team
      t.integer :memberships_purchased

      t.timestamps
    end
    unless index_exists?(:team_payments, :team_id)
      add_index :team_payments, :team_id
    end
  end
end
