# == Schema Information
#
# Table name: cards
#
#  id                :integer          not null, primary key
#  first_name        :string(255)
#  last_name         :string(255)
#  position          :string(255)
#  highlights        :string(255)
#  team_name         :string(255)
#  card_name         :string(255)
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  image             :string(255)
#  background        :string(255)
#  background_tile   :boolean
#  membership_id     :integer
#  background1_color :string(255)
#  background2_color :string(255)
#  address_color     :string(255)
#  details_color     :string(255)
#  name_color        :string(255)
#  icon_color        :string(255)
#  sport             :string(255)
#  hometown          :string(255)
#  season            :string(255)
#  year              :string(255)
#  league            :string(255)
#  handed            :string(255)
#  user_token        :string(255)
#  url_alias         :string(255)
#

class Card < ActiveRecord::Base
  before_save :clean_url_alias

  after_create :send_notification
  after_create :use_payment
  after_destroy :release_payment
  after_update :crop_image

  belongs_to :user
  belongs_to :public_page
  belongs_to :membership, :dependent => :destroy
  has_one :team, :through => :membership
  has_many :payments

  attr_accessible :first_name, :last_name, :position, :highlights, :team_name, :card_name, :remove_image,
            :background, :background_tile, :remove_background, :card_phones_attributes, :card_emails_attributes,  				  :card_websites_attributes,
            :card_socials_attributes, :stats_attributes, :membership_id, :user_id, :background1_color,
            :background2_color, :details_color, :name_color, :icon_color, :sport, :hometown,
            :season, :year, :league, :handed, :image, :crop_x,
            :crop_y, :crop_w, :crop_h, :user_token,:url_alias, :library_image, :background_cache

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :library_image

  def crop_image
    image.recreate_versions! if crop_x.present?
  end

  def paid_to
    self.payments.select(:paid_to).last.try(:paid_to)
  end

  validates :card_name, :presence => true

  validates_length_of :highlights, :maximum => 100, :allow_blank => true

  has_many :card_phones
  accepts_nested_attributes_for :card_phones, allow_destroy: true

  has_many :card_emails
  accepts_nested_attributes_for :card_emails, allow_destroy: true

  has_many :card_websites
  accepts_nested_attributes_for :card_websites, allow_destroy: true

  has_many :card_socials
  accepts_nested_attributes_for :card_socials, allow_destroy: true

  has_many :stats
  accepts_nested_attributes_for :stats, allow_destroy: true



  has_many :shares, as: :shareable

  has_many :contacts

  mount_uploader :image, ImageUploader
  mount_uploader :background, BackgroundUploader

  def paid?
    return true if !user.nil? && user.admin?
    paid_to_time = self.paid_to
    (paid_to_time && paid_to_time > Time.zone.now)
  end

  def send_notification
    if self.user_id.blank?
      Notifications.new_card(self).deliver
    end
  end

  # Begin autocomplete
  def share_user_name
    share_user.try(:name)
  end

  def share_user_name=(name)
    self.share_user = User.find_by_name(name)
  end
  # End autocomplete

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def release_payment
    p = Payment.where(card_id: self.id).first
    p.update_column('card_id', nil) if p
  end

  def use_payment
    p = Payment.where(["user_id = ? AND card_id IS NULL AND (paid_to IS NULL OR paid_to > ?)", self.user_id, Time.zone.now]).first
    if p
      p.card_id = self.id
      p.save(validate: false)
    end
  end
  def clean_url_alias
    self.url_alias = url_alias.gsub(/https?:\/\/|[\/\?&'"\(\)]/, '') if url_alias
  end
end
