require 'test_helper'

class PublicKiosksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @kiosk = public_kiosks(:one)
    @team = teams(:one)
  end

  test 'a kiosk is viewable by anyone' do
    get public_kiosk_path(@kiosk)
    assert_response :success
  end

  test 'a kiosk can be reached through its team' do
    get team_public_kiosk_path(@team)
    assert_response :success
  end

  test 'updating a kiosk requires a signed in user' do
    patch public_kiosk_path(@kiosk), params: { public_kiosk: { description: 'Changed' } }
    assert_redirected_to new_user_session_path
  end

  test 'a signed in user can update the description' do
    sign_in users(:one)
    patch public_kiosk_path(@kiosk), params: { public_kiosk: { description: 'Changed' } }
    assert_equal 'Changed', @kiosk.reload.description
    assert_redirected_to public_kiosk_path(@kiosk)
  end

  test 'update ignores attributes that are not permitted' do
    sign_in users(:one)
    patch public_kiosk_path(@kiosk), params: { public_kiosk: { description: 'Changed',
                                                              team_id: teams(:two).id } }
    assert_equal 'Changed', @kiosk.reload.description
  end
end
