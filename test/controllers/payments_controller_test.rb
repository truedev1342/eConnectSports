require 'test_helper'

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @card = cards(:one)
  end

  test 'the payment form requires a signed in user' do
    get new_payment_path
    assert_redirected_to new_user_session_path
  end

  test 'a signed in user can open the payment form' do
    sign_in @user
    get new_payment_path
    assert_response :success
  end

  test 'the form pre-selects the card being paid for' do
    sign_in @user
    get new_payment_path(card_id: @card.id)
    assert_response :success
  end

  test 'a user with cards left is offered the buy-more price' do
    sign_in @user
    get new_payment_path
    assert_response :success
  end

  test 'a user with no cards left is not offered the buy-more price' do
    @user.update!(cards_purchased: 0)
    sign_in @user
    get new_payment_path
    assert_response :success
  end

  test 'a payment can be shown' do
    sign_in @user
    get payment_path(payments(:one))
    assert_response :success
  end

  test 'the thank you page renders' do
    sign_in @user
    get '/thank_you'
    assert_response :success
  end

  test 'index without a card id bounces back' do
    sign_in @user
    get payments_path
    assert_response :redirect
  end

  test 'a valid promo code adds cards to the account' do
    promo = promo_codes(:one)
    before = @user.cards_purchased
    sign_in @user
    post payments_path, params: { promo_code: promo.code }
    assert_equal before + promo.cards, @user.reload.cards_purchased
    assert promo.reload.used?
    assert_equal @user.id, promo.user_id
  end

  test 'an unknown promo code is rejected' do
    before = @user.cards_purchased
    sign_in @user
    post payments_path, params: { promo_code: 'NOSUCHCODE' }
    assert_equal 'Wrong promo code.', flash[:alert]
    assert_equal before, @user.reload.cards_purchased
  end

  test 'an already used promo code is rejected' do
    sign_in @user
    post payments_path, params: { promo_code: promo_codes(:two).code }
    assert_equal 'Wrong promo code.', flash[:alert]
  end
end
