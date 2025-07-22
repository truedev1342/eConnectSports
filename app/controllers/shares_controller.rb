class SharesController < ApplicationController
	before_action :authenticate_user!
	before_action :load_shareable, :except => ["index"]

	def index
		@user = User.find(params[:user_id])
		@shares = @user.shares.order("created_at DESC").page(params[:page]).per_page(10)
	end

	def new
	  @share = @shareable.shares.new
	end
	  
	def create
	  @share = @shareable.shares.new(share_params)
	  if @share.save
		recipient = @share.destination_email
		sender_name = current_user.full_name
		message = @share.message
		type = @share.shareable_type
		if type == "Card"
			share_url = url_for(@shareable)
			card = @shareable
			record_activity("Shared <b>#{@shareable.card_name}</b> card") #This will call application controller record_activity
		else
			share_url = "#{request.host}/#{current_user.username}"
			card = Card.find_by(id: @shareable.card_id)
			record_activity("Shared <b>Public Page</b>") #This will call application controller record_activity
		end
		ShareMailer.contact(recipient, sender_name, card, message, share_url, type).deliver_now
		return if request.xhr?
	    redirect_to [current_user, :shares], notice: "#{type} shared with #{recipient}."
	  else
	    redirect_back(fallback_location: root_path, allow_other_host: false)
	  end
	end

	def sendmail
		email = params["email"]
		recipient = email["recipient"]
		subject = 'New I Dig It All Sports Card Share'
		message = email["message"]
		ShareMailer.contact(recipient, subject, message).deliver_now
		return if request.xhr?
		redirect_back(fallback_location: root_path, allow_other_host: false)
	end

private

	def load_shareable
	  if params[:share] != nil && params[:share][:contact_card] != nil
	  	@contact_card = params[:share][:contact_card]
	  	@shareable = Card.find_by(id: @contact_card)
	  else
		klass = [Card, PublicPage].detect { |c| params["#{c.name.underscore}_id"]}
		@shareable = klass.find(params["#{klass.name.underscore}_id"])
	  end
	end
	def card_params
		params.require(:card).permit(:first_name, :last_name, :position, :highlights, :team_name, :card_name, :remove_image, :background, :background_tile, :remove_background, :card_phones_attributes, :card_emails_attributes, :card_websites_attributes, :card_socials_attributes, :stats_attributes, :membership_id, :user_id, :background1_color, :background2_color, :details_color, :name_color, :icon_color, :sport, :hometown, :season, :year, :league, :handed, :image, :crop_x, :crop_y, :crop_w, :crop_h, :user_token,:url_alias, :library_image, :background_cache)
	end

	def public_page_params
		params.require(:public_page).permit(:background, :logo, :status, :user_id, :card_id, :background_tile, :remove_background)
	end
	
	def share_params
		params.require(:share).permit(:destination_email, :user_id, :message, :contact_card)
	end

	def user_params
		params.require(:user).permit(:public_page_attributes, :username, :admin, :first_name, :last_name, :name, :email, :password, :password_confirmation, :remember_me, :provider, :uid, :cards_purchased)
	end
end
