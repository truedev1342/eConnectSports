class ContactsController < ApplicationController
before_action :authenticate_user!

  def index
    require 'will_paginate/array'
    @user = User.find(params[:user_id])
    # @contacts = @user.contacts.find(:all)
    @contacts = @user.contacts.all
    @search = Contact.search(params[:search], :user_id => params[:user_id])

    if params[:search]
      @paginated_contacts = @search.all.paginate(:page => params[:page], :per_page => 10)
    else
      @paginated_contacts = @contacts.paginate(:page => params[:page], :per_page => 10)
    end

    # @activities = Activity.find_all_by_user_id(current_user.id, :order => 'created_at DESC', :limit => 5)
    @activities = Activity.where(user_id: current_user.id).order(created_at: :desc).limit(5)

    respond_to do |format|
      format.html
      format.json { render json: @cards }
    end
  end

  def create
    @user = current_user
    @contact = @user.contacts.new(contact_params)

    respond_to do |format|
      if @contact.save
        record_activity("Added new contact") #This will call application controller record_activity
        format.html { redirect_to @user, notice: 'Contact was successfully added.' }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])

    @contact.destroy

    respond_to do |format|
      record_activity("Deleted contact") #This will call application controller record_activity
      format.html { redirect_back(fallback_location: root_path) }
      format.json { head :no_content }
    end
  end

  private

	def activity_params
		params.require(:activity).permit(:action, :browser, :controller, :ip_address, :note, :params)
	end

  def contact_params
		params.require(:contact).permit(:card_id, :user_id)
	end

  def user_params
		params.require(:user).permit(:public_page_attributes, :username, :admin, :first_name, :last_name, :name, :email, :password, :password_confirmation, :remember_me, :provider, :uid, :cards_purchased)
	end
  
end
