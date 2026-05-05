class TeamPaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team_payment, only: [:show, :edit, :update, :destroy]

  def index
    @team_payments = TeamPayment.all
  end

  def show
  end

  def new
    @team_payment = TeamPayment.new
  end

  def edit
  end

  def create
    @team_payment = TeamPayment.new(team_payment_params)
    @current_team = Team.find_by(id: params[:team_payment][:team_id])
    @team_payment.team = @current_team
    @previous_purchased = @current_team.memberships_purchased
    @new_purchased = @team_payment.memberships_purchased
    if @team_payment.purchase
      if @previous_purchased == nil || @previous_purchased == 0
        @total_purchased = @new_purchased
      else
        @total_purchased = @previous_purchased+@new_purchased
      end
      @current_team.update(memberships_purchased: @total_purchased)
      @current_team.save!
      redirect_to url_for(@current_team), :notice => "Success! You can now have #{@total_purchased} members!"
    else
      render :new
    end
  end

  def update
    if @team_payment.update(team_payment_params)
      redirect_to @team_payment, notice: 'Team payment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team_payment.destroy
    redirect_to team_payments_path, notice: 'Team payment was deleted.'
  end

  private

  def set_team_payment
    @team_payment = TeamPayment.find(params[:id])
  end

  def team_payment_params
		params.require(:team_payment).permit(:stripe_card_token, :stripe_customer_token, :email, :amount, :memberships_purchased, :team_id)
	end

  def team_params
    params.require(:team).permit(:name, :owner_id, :memberships_purchased)
  end
end
