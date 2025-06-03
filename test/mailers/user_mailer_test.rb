require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'password_reset is addressed to the user' do
    mail = UserMailer.password_reset(users(:one))
    assert_equal [users(:one).email], mail.to
    assert_equal 'Password Reset', mail.subject
  end

  test 'password_reset comes from the no-reply address' do
    mail = UserMailer.password_reset(users(:one))
    assert_equal ['do_not_reply@idigitallsports.com'], mail.from
  end

  test 'first_touch_message greets the user by first name' do
    mail = UserMailer.first_touch_message(users(:one))
    assert_equal 'iDigItAll Sports | Congratulations! test', mail.subject
  end

  test 'first_touch_message is addressed to the user' do
    mail = UserMailer.first_touch_message(users(:one))
    assert_equal [users(:one).email], mail.to
  end

  test 'user mails render their own document without the shared layout' do
    mail = UserMailer.password_reset(users(:one))
    assert_not_includes mail.body.encoded, 'Have questions?'
  end
end
