class SavedCard < ActiveRecord::Base
  attr_accessible :user_id, :card_id

  belongs_to :user
  belongs_to :card
end
