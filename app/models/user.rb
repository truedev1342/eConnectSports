# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string(255)
#  last_name              :string(255)
#  public_page            :boolean
#  username               :string(255)
#  public_card_id         :integer
#  provider               :string(255)
#  uid                    :string(255)
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  cards_purchased        :integer
#  user_agent             :string(255)
#

class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable,
	# :lockable, :timeoutable and :omniauthable
	devise :invitable, :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :validatable, :omniauthable

	# Validations
	validates_presence_of :first_name, :last_name, :username
	validates_uniqueness_of :email, :case_sensitive => false
	validates_uniqueness_of :username, :case_sensitve => false

	alias_attribute :name, :first_name

	# Setup accessible (or protected) attributes for your model
	attr_accessible :public_page_attributes,
					:username,
					:admin,
					:first_name,
					:last_name,
					:name,
					:email,
					:password,
					:password_confirmation,
					:remember_me,
					:provider,
					:uid,
					:cards_purchased

	has_many :cards, :dependent => :destroy
	has_many :activities, :dependent => :destroy
	has_many :shares, :dependent => :destroy

	has_many :payments

	has_many :memberships, :dependent => :destroy
	has_many :teams, :through => :memberships, :dependent => :destroy

	has_many :contacts

	has_many :saved_card, :dependent => :destroy
  has_many :favorite_cards, :through => :saved_card, class_name: "Card", source: :card, foreign_key: "user_id"

	has_one :public_page, :dependent => :destroy
	accepts_nested_attributes_for :public_page

	after_create :log_create_activity
	after_create :automagic_public_page

	after_invitation_accepted :log_create_activity
	after_invitation_accepted :automagic_public_page

  def admin?
    ['jcubeta@econnectcard.com',
     'jcubeta@playersbrand.com',
     'jcubeta@idigitallsports.com',
     'moulder.kyle@gmail.com',
     'aleks.wq@gmail.com',
     'comeonandroid@gmail.com',
     'example@email.com'
    ].include? email.downcase
  end

  def have_unused_payments?
    !!Payment.select(:id).where("card_id IS NULL AND (paid_to IS NULL OR paid_to > ?)", Time.zone.now).first
  end

	def automagic_public_page
		self.build_public_page
		self.public_page.save
	end

	def record_activity(note)
	    @activity = Activity.new
	    @activity.user = self
	    @activity.note = note
	    @activity.save
	end

	def log_create_activity
		record_activity("Joined I Dig It All Sports") #This will call application controller record_activity
	end

	def full_name
		if first_name? && last_name?
			"#{first_name.capitalize} #{last_name.capitalize}"
		else
			""
		end
	end

	def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
	   	user = User.find_by_email(auth.info.email)
		unless user
		    user = User.create(
				provider:auth.provider,
				uid:auth.uid,
				email:auth.info.email,
				password:Devise.friendly_token[0,20]
		    )
		end
		user
	end

	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
	    data = access_token.info
	    user = User.where(:email => data["email"]).first

	    unless user
	        user = User.create(name: data["name"],
		    		   email: data["email"],
		    		   password: Devise.friendly_token[0,20]
		    		  )
	    end
	    user
	end

	def self.new_with_session(params, session)
		super.tap do |user|
			if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
				user.email = data["email"] if user.email.blank?
			end
		end
	end
end
