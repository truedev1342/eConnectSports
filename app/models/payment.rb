# == Schema Information
#
# Table name: payments
#
#  id                    :integer          not null, primary key
#  status                :string(255)
#  amount                :integer
#  email                 :string(255)
#  transaction_number    :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  stripe_customer_token :string(255)
#  user_id               :integer
#  cards_purchased       :integer
#  card_id               :integer
#  paid_to               :datetime
#  parent_id             :integer
#  period                :integer          default(8)
#

class Payment < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["amount", "card_id", "cards_purchased", "created_at", "email", "id", "paid_to", "parent_id", "period", "status", "stripe_customer_token", "transaction_number", "updated_at", "user_id"]
  end
  
  before_save :activate_period
  belongs_to :card
  belongs_to :user

  PROCESSING, FAILED, SUCCESS = 1, 2, 3
  #PRICE = {'8' => 499, '12' => 999, '24' => 1899, '58' => 3999}
  PRICE = 499
  PRICE_PER_CARD = 299
  # attr_accessible :stripe_card_token, :stripe_customer_token, :email, :amount,
  #   :cards_purchased, :card_id, :period, :renew_payment, :user_id

  attr_accessor :stripe_card_token, :renew_payment

  validates :cards_purchased, :presence => true, :numericality => { :greater_than => 0 }
  #validates :stripe_card_token, :presence => true
  #validates :email, :presence => true

  def purchase(buy_more = false)
    if self.stripe_customer_token.blank? && !self.user.admin?
      # Uncomment after done
      # customer = Stripe::Customer.create(description: email, card: stripe_card_token)
      # self.stripe_customer_token = customer.id
      self.stripe_customer_token = "mock_stripe_customer_#{SecureRandom.hex(10)}"
    end
    if valid?
      self.status = PROCESSING
      if buy_more
        self.amount = cards_purchased * PRICE_PER_CARD   # number purchased multiplied by price in cents
      else
        self.amount = (cards_purchased-1)*PRICE_PER_CARD + PRICE  # number purchased multiplied by price in cents
      end
      # Charge
      if !self.user.admin?
        # Uncomment after done
        # charge = Stripe::Charge.create(
        #  :amount => amount.to_i, # $15.00 this time
        #  :currency => "usd",
        #  :customer => stripe_customer_token,
        #  :description => "Card subscription purchase on iDigitallSports #{self.email}"
        # )
        # if charge.paid
        #   self.transaction_number = charge.id
        #   self.status = SUCCESS
        # else
        #   self.status = FAILED
        # end
        self.transaction_number = "MOCK_TRANSACTION_#{SecureRandom.hex(10)}"
        self.status = SUCCESS
      else
        self.transaction_number = "ADMIN_TRANSACTION"
        self.status = SUCCESS
      end
      if save!
        cards_paid = self.cards_purchased
        if self.card_id.present?
          cards_paid -= 1
        end
        cards_paid.times do
          p = Payment.new()
          p.parent_id = self.id
          p.user_id = self.user_id
          p.period = self.period
          p.save(validate: false)
        end
        true
      else
        false
      end
    end
  rescue Exception => e
    errors.add :base, "There was a problem with your credit card. #{e.message}"
    self.status = FAILED
    return self
  end

  def activate_period
    if self.card_id && !self.paid_to
      self.paid_to = Time.zone.now + self.period.weeks
    end
  end
end
