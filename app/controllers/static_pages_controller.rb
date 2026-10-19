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
    Notifications.contact(params[:email]).deliver_now
    flash[:notice] = "Email was sent successfully."
    
    redirect_to contact_us_path
  end

  def first_touch_email
    @user = User.last
    render 'user_mailer/first_touch_message'
  end

  private

  def user_params
		params.require(:user).permit(:public_page_attributes, :username, :admin, :first_name, :last_name, :name, :email, :password, :password_confirmation, :remember_me, :provider, :uid, :cards_purchased)
	end
end
