# == Schema Information
#
# Table name: payments
#
#  id                    :integer          not null, primary key
#  status                :string(255)
#  amount                :integer
#  email                 :string(255)
#  transaction_number    :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  stripe_customer_token :string(255)
#  user_id               :integer
#  cards_purchased       :integer
#  card_id               :integer
#  paid_to               :datetime
#  parent_id             :integer
#  period                :integer          default(8)
#

require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
