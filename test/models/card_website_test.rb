# == Schema Information
#
# Table name: card_websites
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  card_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)
#

require 'test_helper'

class CardWebsiteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
