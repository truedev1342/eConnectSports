ActiveAdmin.register Share do
    permit_params :user_id, :shareable_type, :destination_email, :message, :contact_card
end