# == Schema Information
#
# Table name: promo_codes
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  cards      :integer          default(1)
#  used       :boolean          default(FALSE)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PromoCode < ApplicationRecord
  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
  def self.ransackable_attributes(auth_object = nil)
    ["cards", "code", "created_at", "id", "updated_at", "used", "user_id"]
  end
  after_initialize :set_code
  before_create :set_code

  belongs_to :user, optional: true

  validates :code, presence: true, uniqueness: true

  def set_code(attributes = nil)
    self.code = Devise.friendly_token if self.code.blank?
  end
end
