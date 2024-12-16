# == Schema Information
#
# Table name: shares
#
#  id                :integer          not null, primary key
#  shareable_id      :integer
#  shareable_type    :string(255)
#  user_id           :integer
#  destination_email :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  message           :text
#  contact_card      :integer
#

require 'test_helper'

class ShareTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
