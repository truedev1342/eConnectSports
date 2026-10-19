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

class Share < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["contact_card", "created_at", "destination_email", "id", "message", "shareable_id", "shareable_type", "updated_at", "user_id"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["shareable", "user"]
  end
  belongs_to :shareable, polymorphic: true
  belongs_to :user
end
