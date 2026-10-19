ActiveAdmin.register PublicPage do
  permit_params :user_id, :status, :background, :logo, :background_tile
  show do |pp|
    attributes_table do
      row :background
      row :logo do
        image_tag(pp.logo)
      end
      row :status
      row :user_id
      row :background_tile
      row :remove_background
    end
    active_admin_comments
  end
end