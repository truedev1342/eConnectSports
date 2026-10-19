class ApplicationMailer < ActionMailer::Base
  before_action :setup_inline_attachments

  layout 'mailer'

  helper LogoHelper

  def setup_inline_attachments
    # making logo embedded to not to depend on its file future name or location
    attachments.inline['logo.png'] = File.read(Rails.root.join('app/assets/images/website/logo', 'idigitall-trading-card-logo.png'))
  end
end
