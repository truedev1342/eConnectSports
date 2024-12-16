require 'test_helper'

class TeamPaymentsControllerTest < ActionController::TestCase
  setup do
    @team_payment = team_payments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:team_payments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create team_payment" do
    assert_difference('TeamPayment.count') do
      post :create, team_payment: { amount: @team_payment.amount, email: @team_payment.email, memberships_purchased: @team_payment.memberships_purchased, status: @team_payment.status, stripe_customer_token: @team_payment.stripe_customer_token, transaction: @team_payment.transaction }
    end

    assert_redirected_to team_payment_path(assigns(:team_payment))
  end

  test "should show team_payment" do
    get :show, id: @team_payment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @team_payment
    assert_response :success
  end

  test "should update team_payment" do
    put :update, id: @team_payment, team_payment: { amount: @team_payment.amount, email: @team_payment.email, memberships_purchased: @team_payment.memberships_purchased, status: @team_payment.status, stripe_customer_token: @team_payment.stripe_customer_token, transaction: @team_payment.transaction }
    assert_redirected_to team_payment_path(assigns(:team_payment))
  end

  test "should destroy team_payment" do
    assert_difference('TeamPayment.count', -1) do
      delete :destroy, id: @team_payment
    end

    assert_redirected_to team_payments_path
  end
end
