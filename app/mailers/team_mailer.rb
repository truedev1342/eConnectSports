class TeamMailer < ActionMailer::Base
  #default from: "do_not_reply@idigitallsports.com"
  default from: "I Dig It All Sports <do_not_reply@idigitallsports.com>"

  def invite(user, team, inviter, current_host)
    @user = user
    @team = team
    @inviter = inviter
    @current_host = current_host
    mail(:to => user.email, :subject => "#{inviter.full_name} has invited you to an I Dig It All Sports team.")
  end

  def send_message(user, mails, message)
    @mails = mails
    @message = message
    mail(:to => mails, :subject => "#{user.full_name} has sent you a message.")
  end
end
