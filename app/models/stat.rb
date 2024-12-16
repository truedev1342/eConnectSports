# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  card_id    :integer
#  name       :string(255)
#  abbr       :string(255)
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kind       :string(255)
#

class Stat < ActiveRecord::Base
  belongs_to :card
  attr_accessible :abbr, :name, :value, :kind
end
