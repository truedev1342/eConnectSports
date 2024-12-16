class Notifications < MailerBase
  default from: "info@idigitallsports.com", to: "info@idigitallsports.com"

  def contact(email_params, sent_at = Time.now)
    @subject = "I Dig It All Sports Website Contact Form: " << email_params[:subject]
    @recipients = "info@idigitallsports.com"
    @from = email_params[:name]+"<"+email_params[:address]+">"
    @sent_on = sent_at
    @website = email_params[:website]
    @message = email_params[:body]
    @name = email_params[:name]
    mail(:subject => @subject, :to => @recipients, :from => @from)
  end

  def new_signup(user)
    @subject = "New Sign Up at iDigitallSports!"
    @user = user
    if user.user_agent.include? 'Mobile'
      @type = 'mobile device'
    else
      @type = 'desktop'
    end
    mail(:subject => @subject, :from => "notifier@idigitallsports.com")
  end

  def first_touch_message(user)
    @user = user
    mail to: user.email, subject: "iDigItAll Sports | Congratulations! #{@user.first_name}"
  end

  def new_card(card)
    @card = card
    mail(
      subject: 'Guest has created new card on iDigitallSports',
      to: 'jcubeta@econnectcard.com'
    )
  end

  def card_expires_in_week(card)
    @card = card
    @user = @card.user
    @recipient_email = @user.email
    mail(
      subject: 'One of your cards expires in a week',
      to: @recipient_email
      )
  end

  def card_expired(card)
    @card = card
    @user = @card.user
    @recipient_email = @user.email
    mail(
      subject: 'One of your cards expired',
      to: @recipient_email
      )
  end
end
