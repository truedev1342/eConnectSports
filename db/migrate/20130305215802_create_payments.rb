class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.string :status
      t.integer :amount
      t.string :email
      t.string :transaction_number

      t.timestamps
    end
  end
end
