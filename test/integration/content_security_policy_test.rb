require 'test_helper'

# The policy is enforced rather than report-only, so an inline handler or an
# un-nonced <script> reintroduced into a view would silently stop working in a
# browser. These assertions catch that in CI instead.
class ContentSecurityPolicyTest < ActionDispatch::IntegrationTest
  PAGES = ['/', '/about', '/contact', '/faq', '/sports', '/affiliate'].freeze

  test 'the policy is enforced, not report only' do
    get root_path
    assert_not_nil response.headers['Content-Security-Policy']
    assert_nil response.headers['Content-Security-Policy-Report-Only']
  end

  test 'script-src does not allow unsafe-inline' do
    get root_path
    script_src = response.headers['Content-Security-Policy'][/script-src[^;]*/]
    assert_not_includes script_src, "'unsafe-inline'"
    assert_includes script_src, 'nonce-'
  end

  test 'the header nonce matches the one rendered into the page' do
    get root_path
    header_nonce = response.headers['Content-Security-Policy'][/'nonce-([^']+)'/, 1]
    body_nonce = response.body[/nonce="([^"]+)"/, 1]
    assert_not_nil header_nonce
    assert_equal header_nonce, body_nonce
  end

  test 'public pages carry no inline event handlers' do
    PAGES.each do |path|
      get path
      assert_response :success
      assert_no_match(/\son[a-z]+\s*=\s*["']/i, response.body,
                      "#{path} still has an inline event handler")
    end
  end

  test 'every inline script tag carries a nonce' do
    PAGES.each do |path|
      get path
      response.body.scan(/<script(?![^>]*\bsrc=)([^>]*)>/i).flatten.each do |attrs|
        assert_includes attrs, 'nonce=', "#{path} has an inline script without a nonce"
      end
    end
  end

  test 'share links expose their target as a data attribute' do
    sign_in users(:one)
    get card_path(cards(:one))
    assert_response :success
    assert_match(/js-share-popup/, response.body)
    assert_match(/data-share-url="http/, response.body)
  end
end
