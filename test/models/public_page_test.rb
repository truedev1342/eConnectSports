require 'test_helper'

class PublicPageTest < ActiveSupport::TestCase
  test 'belongs to a user' do
    assert_equal users(:one), public_pages(:one).user
  end

  test 'is reachable from its user' do
    assert_equal public_pages(:one), users(:one).public_page
  end

  test 'card_id is the foreign key so the card loads through the association' do
    page = public_pages(:one)
    page.update!(card: cards(:one))
    assert_equal cards(:one), page.reload.card
    assert_equal cards(:one).id, page.card_id
  end

  test 'a page without a chosen card is still valid' do
    page = public_pages(:one)
    assert_nil page.card_id
    assert page.valid?
  end

  test 'the card side of the association resolves back to the page' do
    page = public_pages(:one)
    page.update!(card: cards(:one))
    assert_equal page, cards(:one).reload.public_page
  end

  test 'status tracks whether the page is public' do
    assert public_pages(:one).status?
    assert_not public_pages(:two).status?
  end

  test 'shares are polymorphic on the page' do
    share = public_pages(:one).shares.create!(user: users(:one), destination_email: 'x@example.com')
    assert_equal 'PublicPage', share.shareable_type
    assert_equal public_pages(:one), share.shareable
  end
end
