class StaticPagesController < ApplicationController
  layout "static"

  def home
  end

  def about

  end

  def contact
  end

  def affiliate

  end

  def faq

  end

  def send_mail
    Notifications.contact(params[:email]).deliver
    flash[:notice] = "Email was sent successfully."
    
    redirect_to contact_path
  end

  def first_touch_email
    @user = User.last
    render 'user_mailer/first_touch_message'
  end
end
