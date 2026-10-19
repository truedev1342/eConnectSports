require 'test_helper'

class CardEmailTest < ActiveSupport::TestCase
  test 'belongs to a card' do
    assert_equal cards(:one), card_emails(:one).card
  end

  test 'is reachable through its card' do
    assert_includes cards(:one).card_emails, card_emails(:one)
  end

  test 'stores the address' do
    assert_equal 'first@example.com', card_emails(:one).address
  end

  test 'ransackable_attributes exposes only the listed columns' do
    assert_equal %w[address card_id created_at id updated_at],
                 CardEmail.ransackable_attributes.sort
  end
end
