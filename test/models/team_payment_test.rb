# == Schema Information
#
# Table name: team_payments
#
#  id                    :integer          not null, primary key
#  status                :string(255)
#  amount                :integer
#  email                 :string(255)
#  transaction_number    :string(255)
#  stripe_customer_token :string(255)
#  team_id               :integer
#  memberships_purchased :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'test_helper'

class TeamPaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
