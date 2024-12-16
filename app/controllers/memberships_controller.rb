class MembershipsController < ApplicationController
before_filter :authenticate_user!

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(params[:membership])

    respond_to do |format|
      if @membership.save
        format.html { redirect_to @membership, notice: 'Membership was successfully created.' }
        format.json { render json: @membership, status: :created, location: @membership }
      else
        format.html { render action: "new" }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /memberships/1
  # PUT /memberships/1.json
  def update
    @membership = Membership.find(params[:id])

    respond_to do |format|
      if @membership.update_attributes(params[:membership])
        format.html { redirect_to :back, notice: 'Membership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy

    respond_to do |format|
      format.html { redirect_to :back, notice: 'Member removed.' }
      format.json { head :no_content }
    end
  end

  def invites
    @memberships = current_user.memberships.where(:approved => nil)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @memberships }
    end
  end

  def approve
    @membership = Membership.find(params[:id])
    @membership.update_attribute(:approved, true)
    @card = Card.create!(
      "membership_id" => @membership.id,
      "user_id" => current_user.id,
      "first_name" => current_user.first_name,
      "last_name" => current_user.last_name,
      "card_name" => "#{@membership.team.name} Card"
      )
    if @card
      redirect_to edit_membership_card_path(@membership, @card), notice: "You are now a member of #{@membership.team.name}. Please fill out your details below."
    else
      redirect_to :back, notice: "There was a problem adding your team card #{@card}"
    end
  end

  def decline
    @membership = Membership.find(params[:id])
    @membership.update_attribute(:approved, false)
    redirect_to :back, notice: "You declined membership to #{@membership.team.name}."
  end

  def make_admin
    @membership = Membership.find(params[:id])
    @membership.update_attribute(:admin, true)
    redirect_to @membership.team, notice: "#{@membership.user.full_name} is now an administrator."
  end

  def make_member
    @membership = Membership.find(params[:id])
    @membership.update_attribute(:admin, false)
    redirect_to @membership.team, notice: "#{@membership.user.full_name} is no longer an administrator."
  end
end
