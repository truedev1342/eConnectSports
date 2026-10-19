class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  	if params[:id]
    	@user = User.find(params[:id])
    else
    	@user = current_user
    end
    if @user != current_user
      redirect_to '/'+@user.username
    end
    # @cards = Card.find_all_by_user_id(@user.id)
    @cards = Card.where(user_id: @user.id)    
    @public_page = PublicPage.find_by(user_id: @user.id)
    if @public_page && @public_page.card_id
      @public_card = Card.find_by(id: @public_page.card_id)
    end
    # @activities = Activity.find_all_by_user_id(@user.id, :order => 'created_at DESC', :limit => 5)
    @activities = Activity.where(user_id: @user.id).order(created_at: :desc).limit(5)
  end

  #def index
  #  @users = User.all
  #  @autocomplete_users = User.order(:first_name).where("first_name like ? OR last_name like ?", "#{params[:term]}", "#{params[:term]}")
  #  respond_to do |format|
  #    format.html
  #    format.json { @autocomplete_users.map(&:name) }
  #  end
  #end
  private

	def activity_params
		params.require(:activity).permit(:action, :browser, :controller, :ip_address, :note, :params)
	end

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