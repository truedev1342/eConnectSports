# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  card_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contact < ActiveRecord::Base
  def self.ransackable_attributes(auth_object = nil)
    ["card_id", "created_at", "id", "updated_at", "user_id"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["card", "user"]
  end
  belongs_to :user
  belongs_to :card
  # attr_accessible :card_id, :user_id

  validates_presence_of :card_id


end
