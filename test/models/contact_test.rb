require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  test 'belongs to a user and a card' do
    assert_equal users(:one), contacts(:one).user
    assert_equal cards(:two), contacts(:one).card
  end

  test 'card_id is required' do
    contact = Contact.new(user: users(:one))
    assert_not contact.valid?
    assert_includes contact.errors.attribute_names, :card_id
  end

  test 'a contact with a card is valid' do
    assert Contact.new(user: users(:one), card: cards(:one)).valid?
  end

  test 'is reachable from its user' do
    assert_includes users(:one).contacts, contacts(:one)
  end

  test 'is reachable from its card' do
    assert_includes cards(:two).contacts, contacts(:one)
  end
end
