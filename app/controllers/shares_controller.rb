class SharesController < ApplicationController
	before_filter :authenticate_user!
	before_filter :load_shareable, :except => ["index"]

	def index
		@user = User.find(params[:user_id])
		@shares = @user.shares.order("created_at DESC").page(params[:page]).per_page(10)
	end

	def new
	  @share = @shareable.shares.new
	end
	  
	def create
	  @share = @shareable.shares.new(params[:share])
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
			card = Card.find_by_id(@shareable.card_id)
			record_activity("Shared <b>Public Page</b>") #This will call application controller record_activity
		end
		ShareMailer.contact(recipient, sender_name, card, message, share_url, type).deliver
		return if request.xhr?
	    redirect_to [current_user, :shares], notice: "#{type} shared with #{recipient}."
	  else
	    redirect_to :back
	  end
	end

	def sendmail
		email = params["email"]
		recipient = email["recipient"]
		subject = 'New I Dig It All Sports Card Share'
		message = email["message"]
		ShareMailer.contact(recipient, subject, message).deliver
		return if request.xhr?
		redirect_to :back
	end

private

	def load_shareable
	  if params[:share] != nil && params[:share][:contact_card] != nil
	  	@contact_card = params[:share][:contact_card]
	  	@shareable = Card.find_by_id(@contact_card)
	  else
		klass = [Card, PublicPage].detect { |c| params["#{c.name.underscore}_id"]}
		@shareable = klass.find(params["#{klass.name.underscore}_id"])
	  end
	end
end
