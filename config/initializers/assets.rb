# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w(
  application-website.css
  application-website.js
  application-app.css
  application-app.js
  active_admin.css
  active_admin/print.css
  active_admin.js
  bootstrap-wysihtml5/wysiwyg-color.css
  email.css
)
