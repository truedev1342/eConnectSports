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
  belongs_to :card
  attr_accessible :address
end
