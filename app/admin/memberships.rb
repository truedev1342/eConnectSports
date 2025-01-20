ActiveAdmin.register Membership do
    permit_params :user_id, :team_id, :approved, :admin
end