# == Schema Information
#
# Table name: shares
#
#  id                :integer          not null, primary key
#  shareable_id      :integer
#  shareable_type    :string(255)
#  user_id           :integer
#  destination_email :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  message           :text
#  contact_card      :integer
#

class Share < ActiveRecord::Base
  attr_accessible :destination_email, :user_id, :message, :contact_card
  belongs_to :shareable, polymorphic: true
  belongs_to :user
end
