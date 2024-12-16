class VcardMailer < ActionMailer::Base
	default from: "info@idigitallsports.com"

	def send_vcard(vcard_recipient, card, sent_at = Time.now)
		@subject = "I Dig It All Sports Contact Info"
		@recipient = vcard_recipient
		@card = card
		@sent_on = sent_at

	    card = Vpim::Vcard::Maker.make2 do |maker|
	      maker.add_name do |name|
	        name.given = @card.first_name
	        name.family = @card.last_name
	      end

	      maker.add_addr do |addr|
	        addr.preferred = true
	        addr.location = 'work'
	        addr.street = @card.address1.to_s+', '+@card.address2.to_s
	        addr.region = @card.state.to_s
	        addr.country = 'United States'
	        addr.postalcode = @card.zip_code.to_s
	      end

	      #maker.add_photo do |photo|
	      #  photo.link = 'http://example.com/image.png'
	      #end

	      #maker.add_photo do |photo|
	      #  photo.image = "File.open('drdeath.jpg').read # a fake string, real data is too large :-)"
	      #  photo.type = 'jpeg'
	      #end

	      maker.org = @card.business_name.to_s

	      maker.title = @card.title.to_s

	      @card.card_phones.each do |phone|
	        if phone.location == 1
	          @location = 'home'
	        elsif phone.location == 2
	          @location = 'mobile'
	        elsif phone.location == 3
	          @location = 'work'
	        elsif phone.location == 4
	          @location = 'fax'
	        end
	        maker.add_tel('+1'+phone.nmbr) { |t| t.location = @location}
	      end

	      @card.card_emails.each do |email|
	        unless email.blank?
	            maker.add_email(email.address.to_s)
	        end
	      end
	    end

	    attachments["contact.vcf"] = { :content_type => 'text/vcard; charset=utf-8', :content => card.to_s, :encoding => '8bit', :disposition => 'attachment' }
		mail(:subject => "I Dig It All Sports Contact Info", :to => @recipient)
	end
end
