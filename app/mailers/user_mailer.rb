class UserMailer < ActionMailer::Base
  include ApplicationHelper

  # The views are complete HTML documents.
  layout false
  #default from: "do_not_reply@idigitallsports.com"
  default from: "I Dig It All Sports <do_not_reply@idigitallsports.com>"

  def first_touch_message(user)
    @user = user
    @android_app_link = android_app_link
    mail to: @user.email, subject: "iDigItAll Sports | Congratulations! #{@user.first_name}"
  end
end
