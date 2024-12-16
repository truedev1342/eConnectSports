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
  belongs_to :team
  attr_accessible :background, :background_tile, :logo, :team_id, :description, :remove_background, :remove_logo

  mount_uploader :logo, LogoUploader
  mount_uploader :background, BackgroundUploader
end
