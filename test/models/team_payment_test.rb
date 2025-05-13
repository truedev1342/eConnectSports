require 'test_helper'
require 'minitest/mock'

class TeamPaymentTest < ActiveSupport::TestCase
  def valid_payment(overrides = {})
    TeamPayment.new({
      team: teams(:one),
      email: 'buyer@example.com',
      memberships_purchased: 3,
      stripe_card_token: 'tok_visa'
    }.merge(overrides))
  end

  def stub_stripe(paid: true)
    customer = Struct.new(:id).new('cus_test_123')
    charge = Struct.new(:paid, :id).new(paid, 'ch_test_123')
    Stripe::Customer.stub(:create, customer) do
      Stripe::Charge.stub(:create, charge) do
        yield
      end
    end
  end

  test 'a complete payment is valid' do
    assert valid_payment.valid?
  end

  test 'memberships_purchased is required' do
    payment = valid_payment(memberships_purchased: nil)
    assert_not payment.valid?
    assert_includes payment.errors.attribute_names, :memberships_purchased
  end

  test 'memberships_purchased must be greater than zero' do
    payment = valid_payment(memberships_purchased: 0)
    assert_not payment.valid?
    assert_includes payment.errors.attribute_names, :memberships_purchased
  end

  test 'a card token is required' do
    payment = valid_payment(stripe_card_token: nil)
    assert_not payment.valid?
    assert_includes payment.errors.attribute_names, :stripe_card_token
  end

  test 'an email is required' do
    payment = valid_payment(email: nil)
    assert_not payment.valid?
    assert_includes payment.errors.attribute_names, :email
  end

  test 'the card token is not a database column' do
    assert_not_includes TeamPayment.column_names, 'stripe_card_token'
    assert_respond_to valid_payment, :stripe_card_token
  end

  test 'purchase does nothing when the payment is invalid' do
    payment = valid_payment(memberships_purchased: 0)
    assert_no_difference 'TeamPayment.count' do
      payment.purchase
    end
    assert_nil payment.status
  end

  test 'purchase prices memberships at 999 cents each' do
    payment = valid_payment(memberships_purchased: 3)
    stub_stripe { payment.purchase }
    assert_equal 2997, payment.amount
  end

  test 'purchase records the stripe customer and transaction' do
    payment = valid_payment
    stub_stripe { payment.purchase }
    assert_equal 'cus_test_123', payment.stripe_customer_token
    assert_equal 'ch_test_123', payment.transaction_number
  end

  test 'purchase persists the payment' do
    payment = valid_payment
    assert_difference 'TeamPayment.count' do
      stub_stripe { payment.purchase }
    end
    assert payment.persisted?
  end

  test 'a paid charge is marked successful' do
    payment = valid_payment
    stub_stripe(paid: true) { payment.purchase }
    assert_equal TeamPayment::SUCCESS.to_s, payment.status
  end

  test 'an unpaid charge is marked failed' do
    payment = valid_payment
    stub_stripe(paid: false) { payment.purchase }
    assert_equal TeamPayment::FAILED.to_s, payment.status
  end

  test 'a stripe error is reported on the record instead of raising' do
    payment = valid_payment
    Stripe::Customer.stub(:create, ->(*) { raise Stripe::StripeError, 'card declined' }) do
      payment.purchase
    end
    assert_equal TeamPayment::FAILED.to_s, payment.status
    assert_includes payment.errors[:base], 'There was a problem with your credit card.'
  end

  test 'status is stored as a string even though the constants are integers' do
    payment = valid_payment
    stub_stripe { payment.purchase }
    assert_kind_of String, payment.status
  end

  test 'status constants are ordered processing, failed, success' do
    assert_equal [1, 2, 3],
                 [TeamPayment::PROCESSING, TeamPayment::FAILED, TeamPayment::SUCCESS]
  end

  test 'belongs to a team' do
    assert_equal teams(:one), team_payments(:one).team
  end
end
