require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  test 'belongs to a user and a team' do
    assert_equal users(:one), memberships(:one).user
    assert_equal teams(:one), memberships(:one).team
  end

  test 'approved and admin flags are read from the record' do
    assert memberships(:one).approved?
    assert memberships(:one).admin?
    assert_not memberships(:two).approved?
    assert_not memberships(:two).admin?
  end

  test 'a user and team are required' do
    membership = Membership.new
    assert_not membership.valid?
    assert_includes membership.errors.attribute_names, :user
    assert_includes membership.errors.attribute_names, :team
  end

  test 'has one card' do
    membership = memberships(:one)
    card = membership.create_card!(card_name: 'Team Card')
    assert_equal card, membership.reload.card
  end

  test 'destroying a membership destroys its card' do
    membership = memberships(:one)
    card = membership.create_card!(card_name: 'Team Card')
    membership.destroy
    assert_not Card.exists?(card.id)
  end
end
