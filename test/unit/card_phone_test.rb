# == Schema Information
#
# Table name: card_phones
#
#  id         :integer          not null, primary key
#  nmbr       :string(255)
#  location   :integer
#  card_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CardPhoneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
