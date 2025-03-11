# == Schema Information
#
# Table name: card_socials
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  kind       :integer
#  card_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CardSocialTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
