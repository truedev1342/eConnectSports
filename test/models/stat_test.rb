require 'test_helper'

class StatTest < ActiveSupport::TestCase
  test 'belongs to a card' do
    assert_equal cards(:one), stats(:one).card
  end

  test 'is reachable through its card' do
    assert_includes cards(:one).stats, stats(:one)
  end

  test 'stores name, abbreviation and value' do
    stat = stats(:one)
    assert_equal 'Batting Average', stat.name
    assert_equal 'AVG', stat.abbr
    assert_equal '.310', stat.value
  end

  test 'value is stored as a string so decimals keep their format' do
    stat = Stat.new(card: cards(:one), name: 'On Base', abbr: 'OBP', value: '.408')
    assert stat.save
    assert_equal '.408', stat.reload.value
  end

  test 'ransackable_attributes exposes only the listed columns' do
    assert_equal %w[abbr card_id created_at id kind name updated_at value],
                 Stat.ransackable_attributes.sort
  end
end
