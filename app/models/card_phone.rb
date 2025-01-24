# == Schema Information
#
# Table name: card_phones
#
#  id         :integer          not null, primary key
#  nmbr       :string(255)
#  location   :integer
#  card_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CardPhone < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["card_id", "created_at", "id", "location", "nmbr", "updated_at"]
  end
  belongs_to :card
  # attr_accessible :location, :nmbr
end
