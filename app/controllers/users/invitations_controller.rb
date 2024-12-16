class Users::InvitationsController < Devise::InvitationsController
  # GET /resource/invitation/new
  def new
    build_resource
    render :new
  end

  # POST /resource/invitation
  def create
    team = Team.find(params[:team_id])
    if current_user.cards_purchased == nil || team.memberships.count >= current_user.cards_purchased+1 || (params[:email_list].split(",").count+team.memberships.count) > current_user.cards_purchased+1
      redirect_to "/payments/new", error: "You much purchase more team memberships before you can invite new members."
    else
      found_memberships = Array.new
      params[:email_list].split(",").each do |email|
        found_user = User.find_by_email(email)
        if found_user
          found_membership = team.memberships.find_by_user_id(found_user.id)
          if found_membership == '' || found_membership == nil
            team.users << found_user
            TeamMailer.invite(found_user, team, current_user, current_host).deliver
          else
            found_memberships << found_user
          end
        else
          user = User.invite!({:email => email}, current_user)
          team.users << user
          set_flash_message :notice, :send_instructions, :email => user.email
        end
      end
      if found_memberships != nil && found_memberships.count > 0
        members_found_notification = "<br><strong>Note: Some emails you entered were already invited.</strong>"
      else
        members_found_notification = ""
      end
      redirect_to team, notice: "Invite sent. The people you invite must accept membership. Once they do, they will show up in the Members tab below. #{members_found_notification}"
    end
  end
end