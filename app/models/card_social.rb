# == Schema Information
#
# Table name: card_socials
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  kind       :integer
#  card_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CardSocial < ApplicationRecord
  include SanitizableUrl

  def self.ransackable_attributes(auth_object = nil)
    ["card_id", "created_at", "id", "kind", "updated_at", "url"]
  end
  belongs_to :card
end
