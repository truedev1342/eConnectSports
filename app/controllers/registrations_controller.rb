class RegistrationsController < Devise::RegistrationsController
  def create
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
      end

    end
    super

    if current_user
      add_guest_card(current_user.id)
      current_user.user_agent = request.user_agent
      current_user.save
      Notifications.new_signup(current_user).deliver
      UserMailer.first_touch_message(current_user).deliver
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
      card.update_attributes(user_id: user_id) if card
      session.delete :user_token
      cookies[:user_token] = {value: '', expires: Time.now - 1.minute}
    end
  end

end
