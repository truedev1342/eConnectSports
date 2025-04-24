require 'test_helper'

class CardTest < ActiveSupport::TestCase
  test 'card_name is required' do
    card = Card.new
    assert_not card.valid?
    assert_includes card.errors.attribute_names, :card_name
  end

  test 'highlights are capped at 100 characters' do
    card = Card.new(card_name: 'Long', highlights: 'x' * 101)
    assert_not card.valid?
    assert_includes card.errors.attribute_names, :highlights
  end

  test 'highlights may be blank' do
    card = Card.new(card_name: 'Blank highlights', highlights: '')
    assert card.valid?
  end

  test 'belongs to a user' do
    assert_equal users(:one), cards(:one).user
  end

  test 'paid? is true for an admin owner' do
    card = cards(:one)
    card.user.update_column(:email, 'example@email.com')
    assert card.reload.paid?
  end

  test 'paid? is false without a payment period' do
    card = cards(:one)
    card.payments.update_all(paid_to: nil)
    assert_not card.reload.paid?
  end

  test 'paid? is true while the paid_to date is in the future' do
    card = cards(:one)
    card.payments.update_all(paid_to: 2.weeks.from_now)
    assert card.reload.paid?
  end

  test 'paid? is false once the paid_to date has passed' do
    card = cards(:one)
    card.payments.update_all(paid_to: 1.day.ago)
    assert_not card.reload.paid?
  end

  test 'paid_to reads the date from the last payment' do
    card = cards(:one)
    paid_to = 3.weeks.from_now.change(usec: 0)
    card.payments.update_all(paid_to: paid_to)
    assert_equal paid_to, card.reload.paid_to
  end

  test 'destroying a card destroys its phone numbers' do
    card = cards(:one)
    phone = card.card_phones.create!(nmbr: '555-0999', location: 1)
    card.destroy
    assert_not CardPhone.exists?(phone.id)
  end

  test 'destroying a card destroys its email addresses' do
    card = cards(:one)
    email = card.card_emails.create!(address: 'extra@example.com')
    card.destroy
    assert_not CardEmail.exists?(email.id)
  end

  test 'destroying a card destroys its websites' do
    card = cards(:one)
    site = card.card_websites.create!(name: 'Extra', url: 'extra.example.com')
    card.destroy
    assert_not CardWebsite.exists?(site.id)
  end

  test 'destroying a card destroys its social links' do
    card = cards(:one)
    social = card.card_socials.create!(url: 'extra.example.com', kind: 1)
    card.destroy
    assert_not CardSocial.exists?(social.id)
  end

  test 'destroying a card destroys its stats' do
    card = cards(:one)
    stat = card.stats.create!(name: 'Runs', abbr: 'R', value: '4')
    card.destroy
    assert_not Stat.exists?(stat.id)
  end

  test 'destroying a card destroys its shares' do
    card = cards(:one)
    share = card.shares.create!(user: users(:one), destination_email: 'x@example.com')
    card.destroy
    assert_not Share.exists?(share.id)
  end

  test 'destroying a card destroys its contacts' do
    card = cards(:one)
    contact = card.contacts.create!(user: users(:one))
    card.destroy
    assert_not Contact.exists?(contact.id)
  end
end
