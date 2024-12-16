class TeamPaymentsController < InheritedResources::Base
  def create
    @team_payment = TeamPayment.new(params[:team_payment])
    @current_team = Team.find_by_id(params[:team_payment][:team_id])
    @team_payment.team = @current_team
    @previous_purchased = @current_team.memberships_purchased
    @new_purchased = @team_payment.memberships_purchased
    if @team_payment.purchase
      if @previous_purchased == nil || @previous_purchased == 0
        @total_purchased = @new_purchased
      else
        @total_purchased = @previous_purchased+@new_purchased
      end
      @current_team.update_attributes(:memberships_purchased => @total_purchased)
      @current_team.save!
      redirect_to url_for(@current_team), :notice => "Success! You can now have #{@total_purchased} members!"
    else
      render :new
    end
  end
end
