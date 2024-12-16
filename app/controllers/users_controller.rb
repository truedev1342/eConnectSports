class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
  	if params[:id]
    	@user = User.find(params[:id])
    else
    	@user = current_user
    end
    if @user != current_user
      redirect_to '/'+@user.username
    end
    @cards = Card.find_all_by_user_id(@user.id)    
    @public_page = PublicPage.find_by_user_id(@user.id)
    if @public_page && @public_page.card_id
      @public_card = Card.find_by_id(@public_page.card_id)
    end
    @activities = Activity.find_all_by_user_id(@user.id, :order => 'created_at DESC', :limit => 5)
  end

  #def index
  #  @users = User.all
  #  @autocomplete_users = User.order(:first_name).where("first_name like ? OR last_name like ?", "#{params[:term]}", "#{params[:term]}")
  #  respond_to do |format|
  #    format.html
  #    format.json { @autocomplete_users.map(&:name) }
  #  end
  #end
end