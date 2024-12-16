# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  team_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  approved   :boolean
#  admin      :boolean
#

class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  has_one :card, :dependent => :destroy
  attr_accessible :approved, :admin, :user_id, :team_id
end
