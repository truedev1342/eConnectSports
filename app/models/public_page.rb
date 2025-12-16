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

class PublicPage < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["background", "background_tile", "card_id", "created_at", "id", "id_value", "logo", "status", "updated_at", "user_id"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["card", "shares", "user"]
  end
  belongs_to :user
  belongs_to :card, optional: true
  mount_uploader :background, BackgroundUploader

  has_many :shares, as: :shareable
end
