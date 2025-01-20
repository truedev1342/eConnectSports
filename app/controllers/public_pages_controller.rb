class PublicPagesController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!,
    :only => [:destroy, :create, :update]

  # GET /public_pages/1
  # GET /public_pages/1.json
  def show
    unless ['html', 'json', nil].include? params[:format]
      # Fix if we have email into username
      # Here can be username: user@gmail and format: com
      params[:username] = params[:username].to_s + '.' + params[:format].to_s
    end
    # debugger
    @user = User.find_by(username: params[:username].to_s)
    if @user.nil?
      @public_card = @card = Card.find_by(url_alias: params[:username])
      if @card.nil?
        render 'static_pages/not_found', status: 404
        return
      end
      # @demo_view = only_demo_card_allowed?(@card)
      if @card
        render 'cards/show' and return
      end
    end
    # debugger
    # render nothing: true and return if @user.nil? # perhaps just a request to a missing route
    head :ok and return if @user.nil? # perhaps just a request to a missing route

    @public_page = @user.public_page

    if @public_page.status?
	    @public_card = Card.find_by(id: @public_page.card_id)

	    respond_to do |format|
	      format.html # show.html.erb
	      format.json { render json: @public_page }
	    end
  	else
  		flash[:error] = "Sorry, that page is not public."
  		redirect_to :root
  	end
  end

  # POST /public_pages
  # POST /public_pages.json
  def create
    @user = current_user
    @public_page = @user.public_page.new(params[:public_page])
  end

  # PUT /public_pages/1
  # PUT /public_pages/1.json
  def update
    @user = User.find(params[:user_id])
    @public_page = @user.public_page

    if @public_page.update_attributes(params[:public_page])
    	record_activity("You updated your <b>public page</b>") #This will call application controller record_activity
    	redirect_to "/#{@user.username}", notice: 'Public page was successfully updated.'
    else
    	redirect_to :back, error: 'Sorry, something went wrong.'
    end
  end

  # DELETE /public_pages/1
  # DELETE /public_pages/1.json
  def destroy
    @user = User.find(params[:user_id])
    @public_page = @user.public_page

    @public_page.destroy

    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.json { head :no_content }
    end
  end
  private
  def card_params
    params.require(:card).permit(:first_name, :last_name, :position, :highlights, :team_name, :card_name, :remove_image, :background, :background_tile, :remove_background, :card_phones_attributes, :card_emails_attributes, :card_websites_attributes, :card_socials_attributes, :stats_attributes, :membership_id, :user_id, :background1_color, :background2_color, :details_color, :name_color, :icon_color, :sport, :hometown, :season, :year, :league, :handed, :image, :crop_x, :crop_y, :crop_w, :crop_h, :user_token,:url_alias, :library_image, :background_cache)
  end

  def public_page_params
		params.require(:public_page).permit(:background, :logo, :status, :user_id, :card_id, :background_tile, :remove_background)
	end

  def user_params
		params.require(:user).permit(:public_page_attributes, :username, :admin, :first_name, :last_name, :name, :email, :password, :password_confirmation, :remember_me, :provider, :uid, :cards_purchased)
	end
  
end
