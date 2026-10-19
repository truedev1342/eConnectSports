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

class Card < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["address_color", "advanced_data", "background", "background1_color", "background2_color", "background_tile", "card_name", "created_at", "details_color", "first_name", "handed", "highlights", "hometown", "icon_color", "id", "image", "last_name", "league", "membership_id", "name_color", "position", "season", "sport", "team_name", "updated_at", "url_alias", "user_id", "user_token", "year"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["card_emails", "card_phones", "card_socials", "card_websites", "contacts", "membership", "payments", "public_page", "shares", "stats", "team", "user"]
  end
  
  before_save :clean_url_alias

  after_create :send_notification
  after_create :use_payment
  after_destroy :release_payment
  after_update :crop_image

  belongs_to :user, optional: true
  has_one :public_page
  belongs_to :membership, optional: true, dependent: :destroy
  has_one :team, :through => :membership
  has_many :payments

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :library_image

  def crop_image
    image.recreate_versions! if crop_x.present?
  end

  def paid_to
    self.payments.select(:paid_to).last.try(:paid_to)
  end

  validates :card_name, :presence => true

  validates_length_of :highlights, :maximum => 100, :allow_blank => true

  has_many :card_phones, dependent: :destroy
  accepts_nested_attributes_for :card_phones, allow_destroy: true

  has_many :card_emails, dependent: :destroy
  accepts_nested_attributes_for :card_emails, allow_destroy: true

  has_many :card_websites, dependent: :destroy
  accepts_nested_attributes_for :card_websites, allow_destroy: true

  has_many :card_socials, dependent: :destroy
  accepts_nested_attributes_for :card_socials, allow_destroy: true

  has_many :stats, dependent: :destroy
  accepts_nested_attributes_for :stats, allow_destroy: true

  has_many :shares, as: :shareable, dependent: :destroy

  has_many :contacts, dependent: :destroy

  mount_uploader :image, ImageUploader
  mount_uploader :background, BackgroundUploader

  def paid?
    return true if !user.nil? && user.admin?
    paid_to_time = self.paid_to
    (paid_to_time && paid_to_time > Time.zone.now)
  end

  PHONE_LOCATIONS = { 1 => 'home', 2 => 'cell', 3 => 'work', 4 => 'work' }.freeze

  # Builds the vCard used by the download action and the vCard mailer.
  def to_vcard
    card = self
    Vpim::Vcard::Maker.make2 do |maker|
      maker.add_name do |name|
        name.given = card.first_name.to_s
        name.family = card.last_name.to_s
      end

      maker.org = card.team_name.to_s if card.team_name.present?
      maker.title = card.position.to_s if card.position.present?

      card.card_phones.each do |phone|
        next if phone.nmbr.blank?

        location = PHONE_LOCATIONS[phone.location] || 'work'
        maker.add_tel("+1#{phone.nmbr}") do |tel|
          tel.location = location
          tel.capability = 'fax' if phone.location == 4
        end
      end

      card.card_emails.each do |email|
        maker.add_email(email.address.to_s) if email.address.present?
      end
    end
  end

  def send_notification
    if self.user_id.blank?
      Notifications.new_card(self).deliver_now
    end
  end

  # Begin autocomplete
  def share_user_name
    share_user.try(:name)
  end

  def share_user_name=(name)
    self.share_user = User.find_by(name: name)
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
