require 'test_helper'

class SharesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @card = cards(:one)
  end

  test 'the share list requires a signed in user' do
    get user_shares_path(@user)
    assert_redirected_to new_user_session_path
  end

  test 'a signed in user can list their shares' do
    sign_in @user
    get user_shares_path(@user)
    assert_response :success
  end

  test 'sharing a card mails the recipient' do
    sign_in @user
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      post card_shares_path(@card), params: {
        share: { destination_email: 'friend@example.com', message: 'Have a look' }
      }
    end
  end

  test 'sharing a card records the share' do
    sign_in @user
    assert_difference 'Share.count', 1 do
      post card_shares_path(@card), params: {
        share: { destination_email: 'friend@example.com', message: 'Have a look' }
      }
    end
    assert_equal 'Card', Share.order(:id).last.shareable_type
  end

  test 'sharing a public page records a public page share' do
    sign_in @user
    post public_page_shares_path(public_pages(:one)), params: {
      share: { destination_email: 'friend@example.com', message: 'Have a look' }
    }
    assert_equal 'PublicPage', Share.order(:id).last.shareable_type
  end
end
