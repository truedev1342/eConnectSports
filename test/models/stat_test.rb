# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  card_id    :integer
#  name       :string(255)
#  abbr       :string(255)
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kind       :string(255)
#

require 'test_helper'

class StatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
