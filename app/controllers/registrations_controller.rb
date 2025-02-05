class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  def create
    Rails.logger.info("Creating user with params: #{params.inspect}")
    if params[:newsletter]
      oauth = AWeber::OAuth.new(AWEBER[:consumer_key], AWEBER[:consumer_secret])
      oauth.authorize_with_access(AWEBER[:access_token], AWEBER[:access_token_secret])
      aweber = AWeber::Base.new(oauth)
      new_sub={}
      new_sub['email']=params[:user][:email]
      new_sub['name']="#{params[:user][:first_name]} #{params[:user][:last_name]}"
      begin
        aweber.account.lists[AWEBER[:list_id]].subscribers.create(new_sub)
      rescue  Exception => e
        Rails.logger.error("Failed to add subscriber to AWeber: #{e.message}")
      end

    end
    super

    if current_user
      add_guest_card(current_user.id)
      current_user.user_agent = request.user_agent
      current_user.save
      # Notifications.new_signup(current_user).deliver              # Uncomment after done
      # UserMailer.first_touch_message(current_user).deliver        # Uncomment after done
    end
  end

  protected

  def after_sign_up_path_for(resource)
    "/users/#{current_user.id}/cards/new"
  end

  def add_guest_card(user_id)
    token = session[:user_token] || cookies[:user_token]
    if token.present?
      card = Card.where(user_token: token).first
      card.update(user_id: user_id) if card
      session.delete :user_token
      cookies[:user_token] = {value: '', expires: Time.now - 1.minute}
    end
  end
  private
  def card_params
    params.require(:card).permit(:first_name, :last_name, :position, :highlights, :team_name, :card_name, :remove_image, :background, :background_tile, :remove_background, :card_phones_attributes, :card_emails_attributes, :card_websites_attributes, :card_socials_attributes, :stats_attributes, :membership_id, :user_id, :background1_color, :background2_color, :details_color, :name_color, :icon_color, :sport, :hometown, :season, :year, :league, :handed, :image, :crop_x, :crop_y, :crop_w, :crop_h, :user_token,:url_alias, :library_image, :background_cache)
  end

  def user_params
    params.require(:user).permit(
      :public_page_attributes, 
      :username, :admin, 
      :first_name, :last_name, 
      :name, :email, :password, 
      :password_confirmation, 
      :remember_me, :provider, 
      :uid, :cards_purchased
    )
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name]) # Permit these parameters for sign up
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name]) # Permit these parameters for account update
  end
  
end
