# Be sure to restart your server when you modify this file.

# The app loads jQuery plugins from the asset pipeline, uses inline handlers in
# a few views, and embeds images from S3 and the social share widgets, so the
# policy is reported first rather than enforced. Tighten it once the reports are
# clean, then drop content_security_policy_report_only.
Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, :data
  policy.img_src     :self, :https, :data
  policy.object_src  :none
  policy.script_src  :self, :https, :unsafe_inline
  policy.style_src   :self, :https, :unsafe_inline
  policy.frame_ancestors :self
end

Rails.application.config.content_security_policy_report_only = true
