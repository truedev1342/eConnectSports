require 'test_helper'
require 'minitest/mock'

class TeamPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @team = teams(:one)
    @team_payment = team_payments(:one)
  end

  def stub_stripe
    customer = Struct.new(:id).new('cus_test_123')
    charge = Struct.new(:paid, :id).new(true, 'ch_test_123')
    Stripe::Customer.stub(:create, customer) do
      Stripe::Charge.stub(:create, charge) do
        yield
      end
    end
  end

  test 'the payment list renders' do
    get team_payments_path
    assert_response :success
  end

  test 'a single payment renders' do
    get team_payment_path(@team_payment)
    assert_response :success
  end

  test 'the new payment form renders' do
    get new_team_payment_path
    assert_response :success
  end

  test 'the edit form renders' do
    get edit_team_payment_path(@team_payment)
    assert_response :success
  end

  test 'a successful purchase adds to the team membership allowance' do
    before = @team.memberships_purchased
    stub_stripe do
      post team_payments_path, params: {
        team_payment: { team_id: @team.id, email: 'buyer@example.com',
                        memberships_purchased: 2, stripe_card_token: 'tok_visa' }
      }
    end
    assert_equal before + 2, @team.reload.memberships_purchased
  end

  test 'a successful purchase redirects to the team' do
    stub_stripe do
      post team_payments_path, params: {
        team_payment: { team_id: @team.id, email: 'buyer@example.com',
                        memberships_purchased: 1, stripe_card_token: 'tok_visa' }
      }
    end
    assert_redirected_to team_path(@team)
  end

  test 'an invalid purchase re-renders the form' do
    post team_payments_path, params: {
      team_payment: { team_id: @team.id, email: '', memberships_purchased: 0 }
    }
    assert_response :success
  end

  test 'updating a payment changes it' do
    patch team_payment_path(@team_payment), params: {
      team_payment: { email: 'changed@example.com' }
    }
    assert_redirected_to team_payment_path(@team_payment)
    assert_equal 'changed@example.com', @team_payment.reload.email
  end

  test 'destroying a payment removes it' do
    assert_difference 'TeamPayment.count', -1 do
      delete team_payment_path(@team_payment)
    end
    assert_redirected_to team_payments_path
  end
end
