require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  test 'cards_purchased is required' do
    payment = Payment.new(user: users(:one))
    assert_not payment.valid?
    assert_includes payment.errors.attribute_names, :cards_purchased
  end

  test 'cards_purchased must be greater than zero' do
    payment = Payment.new(user: users(:one), cards_purchased: 0)
    assert_not payment.valid?
    assert_includes payment.errors.attribute_names, :cards_purchased
  end

  test 'a child payment without a card is valid' do
    payment = Payment.new(user: users(:one), cards_purchased: 1, parent_id: payments(:one).id)
    assert_nil payment.card
    assert payment.valid?
  end

  test 'belongs to a card and a user' do
    assert_equal cards(:one), payments(:one).card
    assert_equal users(:one), payments(:one).user
  end

  test 'activate_period sets paid_to from the period when a card is present' do
    payment = Payment.new(user: users(:one), card: cards(:one), cards_purchased: 1, period: 8)
    payment.save!
    assert_not_nil payment.paid_to
    assert_in_delta 8.weeks.from_now.to_i, payment.paid_to.to_i, 60
  end

  test 'activate_period leaves paid_to alone when it is already set' do
    existing = 1.year.from_now.change(usec: 0)
    payment = Payment.new(user: users(:one), card: cards(:one), cards_purchased: 1,
                          period: 8, paid_to: existing)
    payment.save!
    assert_equal existing, payment.paid_to
  end

  test 'activate_period does nothing without a card' do
    payment = Payment.new(user: users(:one), cards_purchased: 1, period: 8)
    payment.save!
    assert_nil payment.paid_to
  end

  test 'a stripe error is reported on the record instead of raising' do
    payment = Payment.new(user: users(:two), card: cards(:two), cards_purchased: 1, period: 8)
    def payment.save!(*)
      raise Stripe::StripeError, 'card declined'
    end
    payment.purchase
    assert_equal Payment::FAILED, payment.status
    assert payment.errors[:base].any? { |m| m.include?('There was a problem with your credit card.') }
  end

  test 'a programming error is no longer swallowed as a card problem' do
    payment = Payment.new(user: users(:two), card: cards(:two), cards_purchased: 1, period: 8)
    def payment.save!(*)
      raise NotImplementedError, 'boom'
    end
    assert_raises(NotImplementedError) { payment.purchase }
  end

  test 'price constants describe the card pricing in cents' do
    assert_equal 499, Payment::PRICE
    assert_equal 299, Payment::PRICE_PER_CARD
  end

  test 'status constants are ordered processing, failed, success' do
    assert_equal [1, 2, 3], [Payment::PROCESSING, Payment::FAILED, Payment::SUCCESS]
  end
end
