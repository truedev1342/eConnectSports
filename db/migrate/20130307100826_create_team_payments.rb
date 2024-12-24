class CreateTeamPayments < ActiveRecord::Migration[5.2]
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
    add_index :team_payments, :team_id
  end
end
