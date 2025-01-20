ActiveAdmin.register Team do
    permit_params :owner_id, :name, :memberships_purchased
end
