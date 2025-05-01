require 'test_helper'

class PromoCodeTest < ActiveSupport::TestCase
  test 'an unredeemed code has no user' do
    code = promo_codes(:one)
    assert_nil code.user
    assert code.valid?
  end

  test 'a redeemed code points at the user who used it' do
    assert_equal users(:one), promo_codes(:two).user
    assert promo_codes(:two).used?
  end

  test 'a code is generated when none is given' do
    code = PromoCode.new(cards: 1)
    assert code.code.present?
  end

  test 'a supplied code is kept' do
    assert_equal 'KEEPTHIS', PromoCode.new(code: 'KEEPTHIS', cards: 1).code
  end

  test 'code is required' do
    code = PromoCode.new(cards: 1)
    code.code = nil
    assert_not code.valid?
    assert_includes code.errors.attribute_names, :code
  end

  test 'code must be unique' do
    duplicate = PromoCode.new(code: promo_codes(:one).code, cards: 1)
    assert_not duplicate.valid?
    assert_includes duplicate.errors.attribute_names, :code
  end

  test 'generated codes differ between records' do
    assert_not_equal PromoCode.new.code, PromoCode.new.code
  end
end
