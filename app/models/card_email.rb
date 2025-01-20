# == Schema Information
#
# Table name: card_emails
#
#  id         :integer          not null, primary key
#  address    :string(255)
#  card_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CardEmail < ActiveRecord::Base
  def self.ransackable_attributes(auth_object = nil)
    ["address", "card_id", "created_at", "id", "updated_at"]
  end
  belongs_to :card
  # attr_accessible :address
end
