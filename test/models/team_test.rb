require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test 'belongs to an owner' do
    assert_equal users(:one), teams(:one).owner
  end

  test 'has many memberships' do
    assert_includes teams(:one).memberships, memberships(:one)
  end

  test 'has many users through memberships' do
    assert_includes teams(:one).users, users(:one)
    assert_includes teams(:one).users, users(:two)
  end

  test 'has one public kiosk' do
    assert_equal public_kiosks(:one), teams(:one).public_kiosk
  end

  test 'has many team payments' do
    assert_includes teams(:one).team_payments, team_payments(:one)
  end

  test 'creating a team builds its public kiosk' do
    team = Team.create!(name: 'Brand New Team', owner: users(:two))
    assert_not_nil team.public_kiosk
    assert team.public_kiosk.persisted?
  end

  test 'creating a team logs an activity for the owner' do
    assert_difference 'Activity.count' do
      Team.create!(name: 'Logged Team', owner: users(:two))
    end
    assert_equal 'Created Logged Team Team', Activity.order(:id).last.note
  end

  test 'the create activity is attributed to the owner' do
    team = Team.create!(name: 'Attributed Team', owner: users(:two))
    assert_equal team.owner, Activity.order(:id).last.user
  end

  test 'record_activity stores a note against the owner' do
    assert_difference 'Activity.count' do
      teams(:one).record_activity('Something happened')
    end
    assert_equal 'Something happened', Activity.order(:id).last.note
  end

  test 'destroying a team destroys its memberships' do
    team = teams(:one)
    ids = team.membership_ids
    team.destroy
    assert_empty Membership.where(id: ids)
  end
end
