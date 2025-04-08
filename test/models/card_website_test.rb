require 'test_helper'

class CardWebsiteTest < ActiveSupport::TestCase
  test 'belongs to a card' do
    assert_equal cards(:one), card_websites(:one).card
  end

  test 'sanitized_url keeps an http url as it is' do
    site = CardWebsite.new(url: 'http://example.com')
    assert_equal 'http://example.com', site.sanitized_url
  end

  test 'sanitized_url keeps an https url as it is' do
    site = CardWebsite.new(url: 'https://example.com')
    assert_equal 'https://example.com', site.sanitized_url
  end

  test 'sanitized_url adds a scheme when one is missing' do
    site = CardWebsite.new(url: 'example.com/players')
    assert_equal 'http://example.com/players', site.sanitized_url
  end

  test 'sanitized_url leaves a blank url alone' do
    assert_nil CardWebsite.new.sanitized_url
  end

  test 'a scheme-less fixture url gets a scheme' do
    assert_equal 'http://first.example.com', card_websites(:one).sanitized_url
  end

  test 'an https fixture url is not prefixed twice' do
    assert_equal 'https://second.example.com', card_websites(:two).sanitized_url
  end
end
