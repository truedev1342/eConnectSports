# == Schema Information
#
# Table name: card_emails
#
#  id         :integer          not null, primary key
#  address    :string(255)
#  card_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CardEmailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
