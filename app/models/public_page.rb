# == Schema Information
#
# Table name: public_pages
#
#  id              :integer          not null, primary key
#  status          :boolean
#  background      :string(255)
#  logo            :string(255)
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  card_id         :integer
#  background_tile :boolean
#

class PublicPage < ActiveRecord::Base
  belongs_to :user
  attr_accessible :background, :logo, :status, :user_id, :card_id, :background_tile, :remove_background
  has_one :card
  mount_uploader :background, BackgroundUploader

  has_many :shares, as: :shareable
end
