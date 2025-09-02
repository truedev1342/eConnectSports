require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'the dashboard requires a signed in user' do
    get user_path(users(:one))
    assert_redirected_to new_user_session_path
  end

  test 'a user can see their own dashboard' do
    sign_in users(:one)
    get user_path(users(:one))
    assert_response :success
  end

  test 'the authenticated root shows the dashboard' do
    sign_in users(:one)
    get root_path
    assert_response :success
  end

  test 'visiting another user sends you to their public page' do
    sign_in users(:one)
    get user_path(users(:two))
    assert_redirected_to "/#{users(:two).username}"
  end
end
