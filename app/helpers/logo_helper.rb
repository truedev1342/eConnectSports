module LogoHelper
  def logo_url
    attachments.inline['logo.png'].url
  end
end
