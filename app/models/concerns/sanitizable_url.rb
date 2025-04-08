module SanitizableUrl
  extend ActiveSupport::Concern

  # Returns the stored URL with a scheme so it can be linked to directly.
  #
  # The previous implementation read `url.starts_with? 'http://' || 'https://'`,
  # which Ruby evaluates as `url.starts_with?('http://')` -- the `https://`
  # branch was never checked, so secure URLs came back as
  # "http://https://example.com".
  def sanitized_url
    return url if url.blank?
    return url if url.start_with?('http://', 'https://')

    "http://#{url}"
  end
end
