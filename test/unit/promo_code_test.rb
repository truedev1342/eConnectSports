# == Schema Information
#
# Table name: promo_codes
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  cards      :integer          default(1)
#  used       :boolean          default(FALSE)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PromoCodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
