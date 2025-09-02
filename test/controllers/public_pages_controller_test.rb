require 'test_helper'

class PublicPagesControllerTest < ActionDispatch::IntegrationTest
  test 'a public page is visible to anyone by username' do
    public_pages(:one).update!(status: true)
    get "/#{users(:one).username}"
    assert_response :success
  end

  test 'a private page redirects to the home page' do
    public_pages(:one).update!(status: false)
    get "/#{users(:one).username}"
    assert_redirected_to root_path
    assert_equal 'Sorry, that page is not public.', flash[:error]
  end

  test 'an unknown username with no matching card renders not found' do
    get '/no_such_user_or_card'
    assert_response :not_found
  end

  test 'a url alias falls through to the card' do
    get "/#{cards(:one).url_alias}"
    assert_response :success
  end

  test 'updating a public page requires a signed in user' do
    patch user_public_page_path(users(:one), public_pages(:one)),
          params: { public_page: { status: true } }
    assert_redirected_to new_user_session_path
  end

  test 'an owner can publish their page' do
    public_pages(:one).update!(status: false)
    sign_in users(:one)
    patch user_public_page_path(users(:one), public_pages(:one)),
          params: { public_page: { status: true } }
    assert public_pages(:one).reload.status?
  end
end
