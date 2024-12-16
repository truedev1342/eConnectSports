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

class CardSocial < ActiveRecord::Base
  belongs_to :card
  attr_accessible :kind, :url

  def sanitized_url
    if self.url.starts_with? 'http://' || 'https://'
      self.url
    else
      'http://'+self.url
    end
  end
end
