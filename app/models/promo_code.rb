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

class PromoCode < ActiveRecord::Base
  after_initialize :set_code
  before_create :set_code
  attr_accessible :cards, :code, :used

  belongs_to :user

  validates :code, presence: true, uniqueness: true

  def set_code(attributes = nil)
    self.code = Devise.friendly_token if self.code.blank?
  end
end
