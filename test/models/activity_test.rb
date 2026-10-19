require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  test 'belongs to a user' do
    assert_equal users(:one), activities(:one).user
  end

  test 'an activity recorded for a signed out visitor is valid' do
    activity = Activity.new(note: 'Viewed a card', controller: 'cards', action: 'show')
    assert activity.valid?
    assert activity.save
  end

  test 'is reachable from its user' do
    assert_includes users(:one).activities, activities(:one)
  end

  test 'is destroyed with its user' do
    user = users(:one)
    activity = user.activities.create!(note: 'Temporary')
    user.destroy
    assert_not Activity.exists?(activity.id)
  end

  test 'stores the request context' do
    activity = activities(:one)
    assert_equal 'users', activity.controller
    assert_equal 'create', activity.action
    assert_equal '127.0.0.1', activity.ip_address
  end
end
