# Be sure to restart your server when you modify this file.

# The application does not use any of these browser features, so deny them.
Rails.application.config.permissions_policy do |policy|
  policy.camera      :none
  policy.gyroscope   :none
  policy.microphone  :none
  policy.usb         :none
  policy.fullscreen  :self
  policy.payment     :self
end
