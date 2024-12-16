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

class CardWebsite < ActiveRecord::Base
  belongs_to :card
  attr_accessible :url, :name

  def sanitized_url
    if self.url.starts_with? 'http://' || 'https://'
      self.url
    else
      'http://'+self.url
    end
  end
end
