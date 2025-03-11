# == Schema Information
#
# Table name: public_kiosks
#
#  id              :integer          not null, primary key
#  team_id         :integer
#  background      :string(255)
#  background_tile :boolean
#  logo            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  description     :text
#

require 'test_helper'

class PublicKioskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
