# == Schema Information
#
# Table name: team_payments
#
#  id                    :integer          not null, primary key
#  status                :string(255)
#  amount                :integer
#  email                 :string(255)
#  transaction_number    :string(255)
#  stripe_customer_token :string(255)
#  team_id               :integer
#  memberships_purchased :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class TeamPayment < ActiveRecord::Base
  belongs_to :team

  PROCESSING, FAILED, SUCCESS = 1, 2, 3

  attr_accessible :stripe_card_token, :stripe_customer_token, :email, :amount, :memberships_purchased, :team_id

  attr_accessor :stripe_card_token

  validates :memberships_purchased, :presence => true, :numericality => { :greater_than => 0 }
  validates :stripe_card_token, :presence => true
  validates :email, :presence => true

  def purchase
    if valid?
    	self.status = PROCESSING
    	customer = Stripe::Customer.create(description:email,card: stripe_card_token)
    	self.stripe_customer_token = customer.id
      self.amount = memberships_purchased*999 # number purchased multiplied by price in cents
	    # Charge
	    charge = Stripe::Charge.create(
	     :amount => amount, # $15.00 this time
	     :currency => "usd",
	     :customer => stripe_customer_token,
	     :description => email
	    )
	    if charge.paid
	      self.transaction_number = charge.id
	      self.status = SUCCESS
	    else
	      self.status = FAILED
	    end
	    save!
    end
  rescue Exception => e
    errors.add :base, "There was a problem with your credit card."
    self.status = FAILED
    return self
  end
end
