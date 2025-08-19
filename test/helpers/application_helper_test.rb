require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include Devise::Test::ControllerHelpers

  test 'app_url points at the public site' do
    assert_equal 'https://idigitallsports.com', app_url
  end

  test 'android_app_link points at the play store listing' do
    assert_includes android_app_link, 'play.google.com'
    assert_includes android_app_link, 'com.idigitallsports.app'
  end

  test 'total_cards_purchased is zero for a visitor' do
    assert_equal 0, total_cards_purchased
  end

  test 'total_cards_purchased returns the purchased count for a signed in user' do
    sign_in users(:one)
    assert_equal 5, total_cards_purchased
  end

  test 'total_cards_purchased is zero when the count was never set' do
    users(:one).update_column(:cards_purchased, nil)
    sign_in users(:one)
    assert_equal 0, total_cards_purchased
  end

  test 'current_user_invites is nil for a visitor' do
    assert_nil current_user_invites
  end

  test 'current_user_invites lists memberships awaiting approval' do
    sign_in users(:two)
    memberships(:two).update!(approved: nil)
    assert_includes current_user_invites, memberships(:two)
  end

  test 'current_user_memberships lists approved memberships only' do
    sign_in users(:one)
    assert_includes current_user_memberships, memberships(:one)
    assert_not_includes current_user_memberships, memberships(:two)
  end

  test 'notification_count is nil for a visitor' do
    assert_nil notification_count
  end

  test 'notification_count counts pending invites' do
    sign_in users(:two)
    memberships(:two).update!(approved: nil)
    assert_equal 1, notification_count
  end
end
