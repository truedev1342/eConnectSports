require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'the contact directory requires a signed in user' do
    get user_contacts_path(@user)
    assert_redirected_to new_user_session_path
  end

  test 'a signed in user can browse their contacts' do
    sign_in @user
    get user_contacts_path(@user)
    assert_response :success
  end

  test 'the directory can be filtered by card first name' do
    sign_in @user
    get user_contacts_path(@user), params: { q: { card_first_name_eq: 'second' } }
    assert_response :success
  end

  test 'adding a contact records it against the user' do
    sign_in @user
    assert_difference 'Contact.count', 1 do
      post user_contacts_path(@user), params: { contact: { card_id: cards(:one).id } }
    end
  end

  test 'adding a contact logs an activity' do
    sign_in @user
    assert_difference 'Activity.count', 1 do
      post user_contacts_path(@user), params: { contact: { card_id: cards(:one).id } }
    end
  end

  test 'removing a contact deletes it' do
    sign_in @user
    assert_difference 'Contact.count', -1 do
      delete user_contact_path(@user, contacts(:one))
    end
  end
end
