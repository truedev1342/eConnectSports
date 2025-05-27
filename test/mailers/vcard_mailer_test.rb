require 'test_helper'

class VcardMailerTest < ActionMailer::TestCase
  test 'send_vcard addresses the given recipient' do
    mail = VcardMailer.send_vcard('friend@example.com', cards(:one))
    assert_equal ['friend@example.com'], mail.to
    assert_equal 'I Dig It All Sports Contact Info', mail.subject
  end

  test 'send_vcard comes from the info address' do
    mail = VcardMailer.send_vcard('friend@example.com', cards(:one))
    assert_equal ['info@idigitallsports.com'], mail.from
  end

  test 'send_vcard attaches a vcard file' do
    mail = VcardMailer.send_vcard('friend@example.com', cards(:one))
    attachment = mail.attachments['contact.vcf']
    assert_not_nil attachment
    assert_equal 'text/vcard', attachment.mime_type
  end

  test 'the attachment contains the card details' do
    mail = VcardMailer.send_vcard('friend@example.com', cards(:one))
    body = mail.attachments['contact.vcf'].body.decoded
    assert_includes body, 'BEGIN:VCARD'
    assert_includes body, 'player'
    assert_includes body, 'first@example.com'
  end

  test 'send_vcard builds without raising for a card with no details' do
    card = Card.create!(card_name: 'Bare Card')
    assert_nothing_raised { VcardMailer.send_vcard('friend@example.com', card).message }
  end
end
