require 'test_helper'

class CardPhoneTest < ActiveSupport::TestCase
  test 'belongs to a card' do
    assert_equal cards(:one), card_phones(:one).card
  end

  test 'is reachable through its card' do
    assert_includes cards(:one).card_phones, card_phones(:one)
  end

  test 'stores the number and location' do
    phone = card_phones(:one)
    assert_equal '555-0100', phone.nmbr
    assert_equal 1, phone.location
  end

  test 'location is an integer column' do
    assert_equal :integer, CardPhone.type_for_attribute('location').type
  end

  test 'ransackable_attributes exposes only the listed columns' do
    assert_equal %w[card_id created_at id location nmbr updated_at],
                 CardPhone.ransackable_attributes.sort
  end
end
