require 'test_helper'

class SavedCardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @card = cards(:two)
  end

  test 'saving a card requires a signed in user' do
    post user_card_save_path(@user, @card)
    assert_redirected_to new_user_session_path
  end

  test 'a signed in user can save a card' do
    sign_in @user
    assert_difference 'SavedCard.count', 1 do
      post user_card_save_path(@user, @card), params: { card_id: @card.id }
    end
  end

  test 'a saved card shows up as a favourite' do
    sign_in @user
    post user_card_save_path(@user, @card), params: { card_id: @card.id }
    assert_includes @user.reload.favorite_cards, @card
  end

  test 'removing a saved card deletes it' do
    SavedCard.create!(user: @user, card: @card)
    sign_in @user
    assert_difference 'SavedCard.count', -1 do
      delete user_card_saved_cards_path(@user, @card), params: { card_id: @card.id }
    end
  end
end
