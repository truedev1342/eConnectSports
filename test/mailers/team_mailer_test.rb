require 'test_helper'

class TeamMailerTest < ActionMailer::TestCase
  test 'invite is addressed to the invited user' do
    mail = TeamMailer.invite(users(:two), teams(:one), users(:one), 'www.example.com')
    assert_equal [users(:two).email], mail.to
  end

  test 'invite names the inviter in the subject' do
    mail = TeamMailer.invite(users(:two), teams(:one), users(:one), 'www.example.com')
    assert_equal 'Test One has invited you to an I Dig It All Sports team.', mail.subject
  end

  test 'invite comes from the no-reply address' do
    mail = TeamMailer.invite(users(:two), teams(:one), users(:one), 'www.example.com')
    assert_equal ['do_not_reply@idigitallsports.com'], mail.from
  end

  test 'send_message goes to every supplied address' do
    recipients = ['a@example.com', 'b@example.com']
    mail = TeamMailer.send_message(users(:one), recipients, 'Practice is cancelled')
    assert_equal recipients, mail.to
  end

  test 'send_message names the sender in the subject' do
    mail = TeamMailer.send_message(users(:one), ['a@example.com'], 'Hello')
    assert_equal 'Test One has sent you a message.', mail.subject
  end

  test 'send_message includes the message body' do
    mail = TeamMailer.send_message(users(:one), ['a@example.com'], 'Practice is cancelled')
    assert_includes mail.body.encoded, 'Practice is cancelled'
  end

  test 'team mails are wrapped in the shared mailer layout' do
    mail = TeamMailer.send_message(users(:one), ['a@example.com'], 'Hello')
    assert_includes mail.body.encoded, 'Have questions?'
  end
end
