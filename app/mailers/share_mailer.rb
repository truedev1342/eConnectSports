class ShareMailer < ActionMailer::Base
	#default from: "do_not_reply@idigitallsports.com"
    default from: "I Dig It All Sports <do_not_reply@idigitallsports.com>"
	
	def contact(recipient, sender_name, card, message, share_url, type, sent_at = Time.now)
		@subject =  "Share from #{sender_name} via I Dig It All Sports"
		@recipients = recipient
		@share_url = share_url
		@sender_name = sender_name
		@card = card
		@type = type
		@sent_on = sent_at
		@message = message
		@headers = {}
		mail :to => @recipients, :subject => @subject
	end
end