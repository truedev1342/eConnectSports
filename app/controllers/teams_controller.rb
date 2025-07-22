class TeamsController < ApplicationController
  before_action :authenticate_user!

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @team = Team.find(params[:id])
    @owner = @team.owner
    @owner_card = @team.cards.find_by(user_id: @owner.id)
    @public_kiosk = @team.public_kiosk
    @approved_memberships = @team.memberships.where(:approved => true).where("admin IS NULL OR admin = ?", false).order("created_at DESC").page(params[:page]).per_page(10)
    @pending_memberships = @team.memberships.where(:approved => nil).order("created_at DESC").page(params[:page]).per_page(10)
    @denied_memberships = @team.memberships.where(:approved => false).order("created_at DESC").page(params[:page]).per_page(10)
    @admin_memberships = @team.memberships.where(:admin => true, :approved => true).order("created_at DESC").page(params[:page]).per_page(10)

    is_member = @team.memberships.find_by(user_id: current_user.id)
    if is_member.blank?
      redirect_to@public_kiosk
    else
      current_user_admin = @team.memberships.where(:user_id => current_user.id, :admin => true)

      if current_user_admin.blank?
        @current_user_is_admin = false
        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @team }
        end
      else
        @current_user_is_admin = true
        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @team }
        end
      end
    end
  end

  # GET /teams/new
  # GET /teams/new.json
  def new
    if check_unpaid(current_user)
      redirect_to new_payment_path
    else
      @team = Team.new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @team }
      end
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    if @team.save
      respond_to do |format|
        @membership = Membership.new(:team_id => @team.id, :user_id => current_user.id, :admin => true, :approved => true)
        if @membership.save
          @card = Card.new(
          "membership_id" => @membership.id,
          "user_id" => current_user.id,
          "first_name" => current_user.first_name,
          "last_name" => current_user.last_name,
          "card_name" => "#{@membership.team.name} Card"
          )
          if @card.save
            format.html do
              redirect_to edit_user_membership_card_path(user_id: current_user.id, membership_id: @membership.id, id: @card.id), 
                          notice: "You have created the #{@membership.team.name} team. Please fill out your details below for your member card."
            end            
          else
            format.html { redirect_back(fallback_location: teams_path, allow_other_host: false, notice: "Could not create card.") }
          end
        else
          format.html { redirect_back(fallback_location: teams_path, allow_other_host: false, notice: "Could not create membership.") }
        end
      end
    else
      format.html { redirect_back(fallback_location: root_path, allow_other_host: false, notice: "Could not create team.") }
      format.json { render json: @team.errors, status: :unprocessable_entity }
    end
  end

  # PUT /teams/1
  # PUT /teams/1.json
  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    redirect_to :root, notice: 'Team deleted.'
  end

  def send_message
    mails = []
    ids = result = params["send_message_to"].split(/,/)
    ids.each do |id|
      user = User.find(id)
      mails.push user.email
    end
    TeamMailer.send_message(current_user, mails, params['message']).deliver_now
    respond_to do |format|
      format.html {redirect_to team_path(id: params["team_id"]), notice: "Message sent."}
    end
  end

  private
  def check_unpaid(current_user)
    if current_user.cards_purchased.nil? || current_user.cards.count >= current_user.cards_purchased
      true
    else
      false
    end
  end
  def card_params
    params.require(:card).permit(:first_name, :last_name, :position, :highlights, :team_name, :card_name, :remove_image, :background, :background_tile, :remove_background, :card_phones_attributes, :card_emails_attributes, :card_websites_attributes, :card_socials_attributes, :stats_attributes, :membership_id, :user_id, :background1_color, :background2_color, :details_color, :name_color, :icon_color, :sport, :hometown, :season, :year, :league, :handed, :image, :crop_x, :crop_y, :crop_w, :crop_h, :user_token,:url_alias, :library_image, :background_cache)
  end

  def membership_params
    params.require(:membership).permit(:approved, :admin, :user_id, :team_id)
  end

  def team_params
    params.require(:team).permit(:name, :owner_id, :memberships_purchased)
  end

  def user_params
		params.require(:user).permit(:public_page_attributes, :username, :admin, :first_name, :last_name, :name, :email, :password, :password_confirmation, :remember_me, :provider, :uid, :cards_purchased)
	end
end
