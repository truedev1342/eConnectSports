require 'test_helper'

class CardSocialTest < ActiveSupport::TestCase
  test 'belongs to a card' do
    assert_equal cards(:one), card_socials(:one).card
  end

  test 'sanitized_url keeps an http url as it is' do
    social = CardSocial.new(url: 'http://twitter.com/first')
    assert_equal 'http://twitter.com/first', social.sanitized_url
  end

  test 'sanitized_url keeps an https url as it is' do
    social = CardSocial.new(url: 'https://twitter.com/first')
    assert_equal 'https://twitter.com/first', social.sanitized_url
  end

  test 'sanitized_url adds a scheme when one is missing' do
    social = CardSocial.new(url: 'twitter.com/first')
    assert_equal 'http://twitter.com/first', social.sanitized_url
  end

  test 'sanitized_url leaves a blank url alone' do
    assert_nil CardSocial.new.sanitized_url
    assert_equal '', CardSocial.new(url: '').sanitized_url
  end

  test 'an https fixture url is not prefixed twice' do
    assert_equal 'https://facebook.com/second', card_socials(:two).sanitized_url
  end
end
