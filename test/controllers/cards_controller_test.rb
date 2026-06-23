require 'test_helper'

class CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @card = cards(:one)
    @user = users(:one)
    @card.payments.update_all(paid_to: 1.month.from_now)
  end

  test 'a card is viewable without signing in' do
    get card_path(@card)
    assert_response :success
  end

  test 'the new card form requires a signed in user' do
    get new_card_path
    assert_redirected_to new_user_session_path
  end

  test 'a signed in user can open the new card form' do
    sign_in @user
    get new_card_path
    assert_response :success
  end

  test 'the edit form requires a signed in user' do
    get edit_card_path(@card)
    assert_redirected_to new_user_session_path
  end

  test 'a signed in user can open the edit form' do
    sign_in @user
    get edit_card_path(@card)
    assert_response :success
  end

  test 'updating a card changes permitted attributes' do
    sign_in @user
    patch card_path(@card), params: { card: { card_name: 'Renamed Card' } }
    assert_equal 'Renamed Card', @card.reload.card_name
  end

  test 'update ignores attributes that are not permitted' do
    sign_in @user
    @card.update_column(:advanced_data, 'original value')
    patch card_path(@card), params: { card: { card_name: 'Renamed Card',
                                              advanced_data: 'injected' } }
    assert_equal 'Renamed Card', @card.reload.card_name
    assert_equal 'original value', @card.advanced_data
  end

  test 'destroying a card removes it' do
    sign_in @user
    assert_difference 'Card.count', -1 do
      delete card_path(@card)
    end
  end

  test 'the vcard download returns a vcard attachment' do
    sign_in @user
    get vcard_user_card_path(@user, @card)
    assert_response :success
    assert_equal 'text/vcard; charset=utf-8', response.headers['Content-Type']
    assert_includes response.body, 'BEGIN:VCARD'
  end

  test 'send_vcard mails the card to the given address' do
    sign_in @user
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      post send_vcard_user_card_path(@user, @card), params: { vcard_email: 'friend@example.com' }
    end
  end

  test 'the calendar page renders' do
    sign_in @user
    get calendar_user_card_path(@user, @card)
    assert_response :success
  end

  test 'check_url_alias rejects a reserved alias' do
    post '/cards/check_url_alias', params: { url_alias: 'admin' }
    assert_response :success
  end
end
