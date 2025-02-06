class PublicKiosksController < InheritedResources::Base
  before_action :authenticate_user!,
    :only => [:destroy, :create, :update]

  # GET /public_kiosks/1
  # GET /public_kiosks/1.json
  def show
    if params[:team_id]
      @team = Team.find_by(id: params[:team_id].to_s)
      @public_kiosk = @team.public_kiosk
      @approved_memberships = @team.memberships.where(:approved => true)
    else
      @public_kiosk = PublicKiosk.find(params[:id])
      @approved_memberships = @public_kiosk.team.memberships.where(:approved => true)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @public_kiosk }
    end
  end

  # POST /public_kiosks
  # POST /public_kiosks.json
  def create
    @team = Team.find(params[:team_id])
    @public_kiosk = @team.build_public_kiosk(public_kiosk_params)
  end

  # PUT /public_kiosks/1
  # PUT /public_kiosks/1.json
  def update
    @public_kiosk = PublicKiosk.find(params[:id])

    if @public_kiosk.update(public_kiosk_params)
    	record_activity("You updated your <b>public kiosk</b>") #This will call application controller record_activity
    	redirect_to @public_kiosk, notice: 'Public kiosk was successfully updated.'
    else
    	redirect_to :back, error: 'Sorry, something went wrong.'
    end
  end

  # DELETE /public_kiosks/1
  # DELETE /public_kiosks/1.json
  def destroy
    @team = Team.find(params[:team_id])
    @public_kiosk = @team.public_kiosk

    @public_kiosk.destroy

    respond_to do |format|
      format.html { redirect_to team_path(@team) }
      format.json { head :no_content }
    end
  end
  private
  def public_kiosk_params
    params.require(:public_kiosk).permit(:background, :background_tile, :logo, :team_id, :description, :remove_background, :remove_logo)
  end

  def team_params
    params.require(:team).permit(:name, :owner_id, :memberships_purchased)
  end
end