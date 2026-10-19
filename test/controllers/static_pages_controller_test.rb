require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'the home page is public' do
    get root_path
    assert_response :success
  end

  test 'the about page is public' do
    get about_path
    assert_response :success
  end

  test 'the contact page is public' do
    get contact_us_path
    assert_response :success
  end

  test 'the affiliate page is public' do
    get affiliate_path
    assert_response :success
  end

  test 'the faq page is public' do
    get faq_path
    assert_response :success
  end

  test 'the sports page renders from its template' do
    get sports_path
    assert_response :success
  end

  test 'submitting the contact form sends a mail' do
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      post '/email', params: { email: { subject: 'Hello', name: 'Jane',
                                        address: 'jane@example.com',
                                        website: 'example.com', body: 'A question' } }
    end
  end

  test 'submitting the contact form redirects back to the contact page' do
    post '/email', params: { email: { subject: 'Hello', name: 'Jane',
                                      address: 'jane@example.com',
                                      website: 'example.com', body: 'A question' } }
    assert_redirected_to contact_us_path
    assert_equal 'Email was sent successfully.', flash[:notice]
  end

  test 'the first touch preview renders the mailer template' do
    get '/first-touch-message'
    assert_response :success
  end
end
