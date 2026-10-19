class VcardMailer < ApplicationMailer
	default from: "info@idigitallsports.com"

	def send_vcard(vcard_recipient, card, sent_at = Time.now)
		@subject = "I Dig It All Sports Contact Info"
		@recipient = vcard_recipient
		@card = card
		@sent_on = sent_at

		attachments["contact.vcf"] = {
			:content_type => 'text/vcard; charset=utf-8',
			:content => @card.to_vcard.to_s,
			:encoding => '8bit',
			:disposition => 'attachment'
		}
		mail(:subject => @subject, :to => @recipient)
	end
end
