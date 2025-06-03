require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  def contact_params(overrides = {})
    {
      subject: 'A question',
      name: 'Jane Visitor',
      address: 'jane@example.com',
      website: 'example.com',
      body: 'How do I make a card?'
    }.merge(overrides)
  end

  test 'contact builds the subject from the submitted subject' do
    mail = Notifications.contact(contact_params)
    assert_equal 'I Dig It All Sports Website Contact Form: A question', mail.subject
  end

  test 'contact tolerates a missing subject' do
    mail = Notifications.contact(contact_params(subject: nil))
    assert_equal 'I Dig It All Sports Website Contact Form: ', mail.subject
  end

  test 'contact goes to the info address' do
    mail = Notifications.contact(contact_params)
    assert_equal ['info@idigitallsports.com'], mail.to
  end

  test 'contact uses the visitor as the sender' do
    mail = Notifications.contact(contact_params)
    assert_equal ['jane@example.com'], mail.from
  end

  test 'contact repeats the message in the body' do
    mail = Notifications.contact(contact_params)
    assert_includes mail.body.encoded, 'How do I make a card?'
  end

  test 'new_signup describes a desktop signup' do
    user = users(:one)
    user.update!(user_agent: 'Mozilla/5.0 (Macintosh)')
    mail = Notifications.new_signup(user)
    assert_includes mail.body.encoded, 'desktop'
  end

  test 'new_signup describes a mobile signup' do
    user = users(:one)
    user.update!(user_agent: 'Mozilla/5.0 (iPhone) Mobile/15E148')
    mail = Notifications.new_signup(user)
    assert_includes mail.body.encoded, 'mobile device'
  end

  test 'new_signup does not blow up when no user agent was recorded' do
    user = users(:one)
    user.update!(user_agent: nil)
    mail = Notifications.new_signup(user)
    assert_includes mail.body.encoded, 'desktop'
  end

  test 'new_signup has its own subject and sender' do
    mail = Notifications.new_signup(users(:one))
    assert_equal 'New Sign Up at iDigitallSports!', mail.subject
    assert_equal ['notifier@idigitallsports.com'], mail.from
  end

  test 'new_card notifies the office about a guest card' do
    mail = Notifications.new_card(cards(:one))
    assert_equal 'Guest has created new card on iDigitallSports', mail.subject
    assert_equal ['jcubeta@econnectcard.com'], mail.to
  end

  test 'card_expires_in_week is addressed to the card owner' do
    mail = Notifications.card_expires_in_week(cards(:one))
    assert_equal [users(:one).email], mail.to
    assert_equal 'One of your cards expires in a week', mail.subject
  end

  test 'card_expired is addressed to the card owner' do
    mail = Notifications.card_expired(cards(:one))
    assert_equal [users(:one).email], mail.to
    assert_equal 'One of your cards expired', mail.subject
  end

  test 'notification mails carry the shared mailer layout' do
    mail = Notifications.card_expired(cards(:one))
    assert_includes mail.body.encoded, 'Have questions?'
  end

  test 'the inline logo is attached for layout rendering' do
    mail = Notifications.card_expired(cards(:one))
    assert mail.attachments.any? { |a| a.filename == 'logo.png' }
  end
end
