require 'test_helper'

class ShareTest < ActiveSupport::TestCase
  test 'belongs to a user' do
    assert_equal users(:one), shares(:one).user
  end

  test 'is shareable against a card' do
    assert_equal cards(:one), shares(:one).shareable
    assert_equal 'Card', shares(:one).shareable_type
  end

  test 'can be shareable against a public page' do
    share = Share.new(shareable: public_pages(:one), user: users(:one),
                      destination_email: 'friend@example.com')
    assert share.save
    assert_equal 'PublicPage', share.reload.shareable_type
  end

  test 'stores the destination address and message' do
    assert_equal 'friend1@example.com', shares(:one).destination_email
    assert_equal 'Take a look at my card.', shares(:one).message
  end

  test 'is reachable from its user' do
    assert_includes users(:one).shares, shares(:one)
  end

  test 'is reachable from the shared card' do
    assert_includes cards(:one).shares, shares(:one)
  end
end
