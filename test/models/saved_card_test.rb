require 'test_helper'

class SavedCardTest < ActiveSupport::TestCase
  test 'belongs to a user and a card' do
    saved = SavedCard.create!(user: users(:one), card: cards(:two))
    assert_equal users(:one), saved.user
    assert_equal cards(:two), saved.card
  end

  test 'a user and card are required' do
    saved = SavedCard.new
    assert_not saved.valid?
    assert_includes saved.errors.attribute_names, :user
    assert_includes saved.errors.attribute_names, :card
  end

  test 'favourite cards read through saved cards' do
    SavedCard.create!(user: users(:one), card: cards(:two))
    assert_includes users(:one).reload.favorite_cards, cards(:two)
  end

  test 'saved cards are destroyed with their user' do
    user = users(:one)
    saved = SavedCard.create!(user: user, card: cards(:two))
    user.destroy
    assert_not SavedCard.exists?(saved.id)
  end
end
