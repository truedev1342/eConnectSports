class SavedCard < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["card_id", "created_at", "id", "updated_at", "user_id"]
  end
  # attr_accessible :user_id, :card_id

  belongs_to :user
  belongs_to :card
end
