# == Schema Information
#
# Table name: public_pages
#
#  id              :integer          not null, primary key
#  status          :boolean
#  background      :string(255)
#  logo            :string(255)
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  card_id         :integer
#  background_tile :boolean
#

require 'test_helper'

class PublicPageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
