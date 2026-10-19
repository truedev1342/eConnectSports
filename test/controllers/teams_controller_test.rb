require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @team = teams(:one)
    @owner = users(:one)
  end

  test 'the team index requires a signed in user' do
    get teams_path
    assert_redirected_to new_user_session_path
  end

  test 'a signed in user can list teams' do
    sign_in @owner
    get teams_path
    assert_response :success
  end

  test 'an admin member can view a team' do
    sign_in @owner
    get team_path(@team)
    assert_response :success
  end

  test 'a non member is sent to the public kiosk' do
    outsider = User.create!(email: 'outsider@test.com', username: 'outsider',
                            first_name: 'out', last_name: 'sider',
                            password: 'password123')
    sign_in outsider
    get team_path(@team)
    assert_redirected_to public_kiosk_path(@team.public_kiosk)
  end

  test 'a signed in user can open the new team form' do
    sign_in @owner
    get new_team_path
    assert_response :success
  end

  test 'updating a team changes its name' do
    sign_in @owner
    patch team_path(@team), params: { team: { name: 'Renamed Team' } }
    assert_redirected_to team_path(@team)
    assert_equal 'Renamed Team', @team.reload.name
  end

  test 'update only permits whitelisted attributes' do
    sign_in @owner
    assert_raises(ActionController::ParameterMissing) do
      patch team_path(@team), params: { not_a_team: { name: 'Nope' } }
    end
  end

  test 'destroying a team removes it' do
    sign_in @owner
    assert_difference 'Team.count', -1 do
      delete team_path(@team)
    end
    assert_redirected_to root_path
  end

  test 'send_message mails every selected member' do
    sign_in @owner
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      post send_team_message_path, params: { 'send_message_to' => users(:two).id.to_s,
                                             'message' => 'Practice cancelled',
                                             'team_id' => @team.id }
    end
    assert_redirected_to team_path(id: @team.id)
  end
end
