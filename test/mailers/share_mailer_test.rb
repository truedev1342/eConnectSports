require 'test_helper'

class ShareMailerTest < ActionMailer::TestCase
  def share_mail
    ShareMailer.contact('friend@example.com', 'Test One', cards(:one),
                        'Have a look', 'http://example.com/first-card', 'card')
  end

  test 'contact is addressed to the recipient' do
    assert_equal ['friend@example.com'], share_mail.to
  end

  test 'contact names the sender in the subject' do
    assert_equal 'Share from Test One via I Dig It All Sports', share_mail.subject
  end

  test 'contact comes from the no-reply address' do
    assert_equal ['do_not_reply@idigitallsports.com'], share_mail.from
  end

  test 'contact includes the message and share url' do
    body = share_mail.body.encoded
    assert_includes body, 'Have a look'
    assert_includes body, 'first-card'
  end

  test 'share mails render their own document without the shared layout' do
    assert_not_includes share_mail.body.encoded, 'Have questions?'
  end
end
