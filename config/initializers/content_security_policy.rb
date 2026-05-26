# Be sure to restart your server when you modify this file.

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, :data
  # Card and background images are served from S3, and the social share widgets
  # embed remote images.
  policy.img_src     :self, :https, :data
  policy.object_src  :none
  # Inline <script> blocks carry a nonce; the inline onClick handlers that used
  # to require 'unsafe-inline' were replaced by app/assets/javascripts/share_popup.js.
  policy.script_src  :self, :https
  # Many views still carry style="..." attributes, which a nonce cannot cover.
  policy.style_src   :self, :https, :unsafe_inline
  policy.frame_ancestors :self
end

Rails.application.config.content_security_policy_nonce_generator =
  ->(request) { request.session.id.to_s.presence || SecureRandom.base64(16) }

Rails.application.config.content_security_policy_nonce_directives = %w[script-src]
