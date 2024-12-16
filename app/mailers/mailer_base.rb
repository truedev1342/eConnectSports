class MailerBase < ActionMailer::Base
  include AbstractController::Callbacks
  before_filter :setup_inline_attachments

  layout 'mailer'

  def setup_inline_attachments
    # making logo embedded to not to depend on its file future name or location
    attachments.inline['logo.png'] = File.read(Rails.root.join('app/assets/images/website/logo', 'idigitall-trading-card-logo.png'))
  end

  module Helper
    def logo_url
      attachments.inline['logo.png'].url
    end
  end
  add_template_helper(Helper)

end
