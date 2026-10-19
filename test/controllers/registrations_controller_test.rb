require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  def signup_params(overrides = {})
    { user: { email: 'signup@test.com', username: 'signup_user',
              first_name: 'sign', last_name: 'up',
              password: 'password123',
              password_confirmation: 'password123' }.merge(overrides) }
  end

  test 'the signup form renders' do
    get new_user_registration_path
    assert_response :success
  end

  test 'signing up creates a user' do
    assert_difference 'User.count', 1 do
      post user_registration_path, params: signup_params
    end
  end

  test 'signing up builds a public page for the new user' do
    post user_registration_path, params: signup_params
    assert_not_nil User.find_by(email: 'signup@test.com').public_page
  end

  test 'signing up records the join activity' do
    post user_registration_path, params: signup_params
    user = User.find_by(email: 'signup@test.com')
    assert_includes user.activities.map(&:note), 'Joined I Dig It All Sports'
  end

  test 'signing up stores the user agent' do
    post user_registration_path, params: signup_params,
         headers: { 'HTTP_USER_AGENT' => 'Mozilla/5.0 (iPhone) Mobile/15E148' }
    assert_includes User.find_by(email: 'signup@test.com').user_agent, 'Mobile'
  end

  test 'signing up without a username is rejected' do
    assert_no_difference 'User.count' do
      post user_registration_path, params: signup_params(username: '')
    end
  end

  test 'a guest card is claimed on signup' do
    guest_card = Card.create!(card_name: 'Guest Card', user_token: 'guest-token-123')
    post user_registration_path, params: signup_params.merge(user_token: 'guest-token-123')
    assert_response :redirect
    assert_not_nil guest_card.reload
  end
end
