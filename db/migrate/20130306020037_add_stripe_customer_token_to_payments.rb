class AddStripeCustomerTokenToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :stripe_customer_token, :string
  end
end
