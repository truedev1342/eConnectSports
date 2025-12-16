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

class CardWebsite < ApplicationRecord
  include SanitizableUrl

  def self.ransackable_attributes(auth_object = nil)
    ["card_id", "created_at", "id", "name", "updated_at", "url"]
  end
  
  belongs_to :card
end
