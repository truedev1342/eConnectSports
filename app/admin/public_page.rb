ActiveAdmin.register PublicPage do
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