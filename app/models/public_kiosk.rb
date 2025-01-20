# == Schema Information
#
# Table name: public_kiosks
#
#  id              :integer          not null, primary key
#  team_id         :integer
#  background      :string(255)
#  background_tile :boolean
#  logo            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  description     :text
#

class PublicKiosk < ActiveRecord::Base
  def self.ransackable_associations(auth_object = nil)
    ["team"]
  end
  def self.ransackable_attributes(auth_object = nil)
    ["background", "background_tile", "created_at", "description", "id", "logo", "team_id", "updated_at"]
  end
  belongs_to :team
  # attr_accessible :background, :background_tile, :logo, :team_id, :description, :remove_background, :remove_logo

  mount_uploader :logo, LogoUploader
  mount_uploader :background, BackgroundUploader
end
