class PublicKiosksController < InheritedResources::Base
  before_filter :authenticate_user!,
    :only => [:destroy, :create, :update]

  # GET /public_kiosks/1
  # GET /public_kiosks/1.json
  def show
    if params[:team_id]
      @team = Team.find_by_id(params[:team_id].to_s)
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
    @public_kiosk = @team.public_kiosk.new(params[:public_kiosk])
  end

  # PUT /public_kiosks/1
  # PUT /public_kiosks/1.json
  def update
    @public_kiosk = PublicKiosk.find(params[:id])

    if @public_kiosk.update_attributes(params[:public_kiosk])
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
end