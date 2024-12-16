require 'test_helper'

class CardsControllerTest < ActionController::TestCase
  setup do
    @card = cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create card" do
    assert_difference('Card.count') do
      post :create, card: { address1: @card.address1, address2: @card.address2, card_name: @card.card_name, city: @card.city, first_name: @card.first_name, last_name: @card.last_name, state: @card.state, title: @card.title, zip_code: @card.zip_code }
    end

    assert_redirected_to card_path(assigns(:card))
  end

  test "should show card" do
    get :show, id: @card
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @card
    assert_response :success
  end

  test "should update card" do
    put :update, id: @card, card: { address1: @card.address1, address2: @card.address2, card_name: @card.card_name, city: @card.city, first_name: @card.first_name, last_name: @card.last_name, state: @card.state, title: @card.title, zip_code: @card.zip_code }
    assert_redirected_to card_path(assigns(:card))
  end

  test "should destroy card" do
    assert_difference('Card.count', -1) do
      delete :destroy, id: @card
    end

    assert_redirected_to cards_path
  end
end
