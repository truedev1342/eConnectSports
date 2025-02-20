# Be sure to restart your server when you modify this file.

# Specify a serializer for the signed and encrypted cookie jars.
# Valid options are :json, :marshal, and :hybrid.
#
# :hybrid reads existing Marshal cookies but writes JSON, so sessions issued
# before this change keep working. Once they have all expired this can move to
# :json and drop Marshal deserialization of cookie data entirely.
Rails.application.config.action_dispatch.cookies_serializer = :hybrid
