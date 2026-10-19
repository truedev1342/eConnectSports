require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'first_touch_message greets the user by first name' do
    mail = UserMailer.first_touch_message(users(:one))
    assert_equal 'iDigItAll Sports | Congratulations! test', mail.subject
  end

  test 'first_touch_message is addressed to the user' do
    mail = UserMailer.first_touch_message(users(:one))
    assert_equal [users(:one).email], mail.to
  end

  test 'first_touch_message comes from the no-reply address' do
    mail = UserMailer.first_touch_message(users(:one))
    assert_equal ['do_not_reply@idigitallsports.com'], mail.from
  end

  test 'first_touch_message links to the android app' do
    mail = UserMailer.first_touch_message(users(:one))
    assert_includes mail.body.encoded, 'com.idigitallsports.app'
  end

  test 'user mails render their own document without the shared layout' do
    mail = UserMailer.first_touch_message(users(:one))
    assert_not_includes mail.body.encoded, 'Have questions?'
  end

  test 'password resets are handled by Devise, not UserMailer' do
    assert_not UserMailer.respond_to?(:password_reset)
    assert Devise::Mailer.instance_methods.include?(:reset_password_instructions)
  end
end
