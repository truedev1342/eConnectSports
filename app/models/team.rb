# == Schema Information
#
# Table name: teams
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  owner_id              :integer
#  memberships_purchased :integer
#

class Team < ActiveRecord::Base
	attr_accessible :name, :owner_id, :memberships_purchased
	has_one :public_kiosk
	has_many :memberships, :dependent => :destroy
	has_many :users, :through => :memberships
	has_many :cards, :through => :memberships
	has_many :team_payments
	belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id', :validate => true

	after_create :log_create_activity
	after_create :automagic_public_kiosk

	def record_activity(note)
	    @activity = Activity.new
	    @activity.user = self.owner
	    @activity.note = note
	    @activity.save
	end

	def automagic_public_kiosk
		self.build_public_kiosk
		self.public_kiosk.save
	end

	def log_create_activity
		record_activity("Created #{self.name} Team") #This will call application controller record_activity
	end
end
