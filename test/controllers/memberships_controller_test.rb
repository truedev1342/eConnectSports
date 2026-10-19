require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:two)
    @membership = memberships(:two)
  end

  test 'the invites list requires a signed in user' do
    get invites_path
    assert_redirected_to new_user_session_path
  end

  test 'a signed in user sees their pending invites' do
    @membership.update!(approved: nil)
    sign_in @user
    get invites_path
    assert_response :success
  end

  test 'approving a membership creates a team card' do
    @membership.update!(approved: nil)
    sign_in @user
    assert_difference 'Card.count', 1 do
      get approve_user_membership_path(@user, @membership)
    end
    assert @membership.reload.approved?
  end

  test 'declining a membership marks it declined' do
    @membership.update!(approved: nil)
    sign_in @user
    get decline_user_membership_path(@user, @membership)
    assert_equal false, @membership.reload.approved
  end

  test 'make_admin promotes the member' do
    sign_in @user
    get make_admin_user_membership_path(@user, @membership)
    assert @membership.reload.admin?
  end

  test 'make_member demotes the member' do
    @membership.update!(admin: true)
    sign_in @user
    get make_member_user_membership_path(@user, @membership)
    assert_not @membership.reload.admin?
  end

  test 'destroying a membership removes it' do
    sign_in @user
    assert_difference 'Membership.count', -1 do
      delete user_membership_path(@user, @membership)
    end
  end
end
