# == Schema Information
#
# Table name: activities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  note       :string(255)
#  browser    :string(255)
#  ip_address :string(255)
#  controller :string(255)
#  action     :string(255)
#  params     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
