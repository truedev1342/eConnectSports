require 'test_helper'

# Walks the main journey end to end: sign up, build a card, publish a public
# page, share it, and have someone collect it as a contact.
class CardLifecycleTest < ActionDispatch::IntegrationTest
  test 'a new user signs up and gets a public page' do
    post user_registration_path, params: {
      user: { email: 'journey@test.com', username: 'journey_user',
              first_name: 'journey', last_name: 'user',
              password: 'password123', password_confirmation: 'password123' }
    }

    user = User.find_by(email: 'journey@test.com')
    assert_not_nil user
    assert_not_nil user.public_page, 'signup should build a public page'
    assert_includes user.activities.map(&:note), 'Joined I Dig It All Sports'
  end

  test 'an owner publishes a card on their public page' do
    user = users(:one)
    card = cards(:one)
    sign_in user

    patch user_public_page_path(user, public_pages(:one)),
          params: { public_page: { status: true, card_id: card.id } }

    page = public_pages(:one).reload
    assert page.status?
    assert_equal card, page.card

    sign_out user
    get "/#{user.username}"
    assert_response :success
  end

  test 'a card is shared by email and collected as a contact' do
    owner = users(:one)
    card = cards(:one)
    collector = users(:two)

    sign_in owner
    assert_difference ['Share.count', 'ActionMailer::Base.deliveries.size'], 1 do
      post card_shares_path(card), params: {
        share: { destination_email: collector.email, message: 'Here is my card' }
      }
    end
    sign_out owner

    sign_in collector
    assert_difference 'Contact.count', 1 do
      post user_contacts_path(collector), params: { contact: { card_id: card.id } }
    end
    assert_includes collector.reload.contacts.map(&:card), card
  end

  test 'a card and everything hanging off it is removed together' do
    user = users(:one)
    card = cards(:one)
    phone = card.card_phones.create!(nmbr: '555-0777', location: 1)
    stat = card.stats.create!(name: 'Runs', abbr: 'R', value: '7')

    sign_in user
    assert_difference 'Card.count', -1 do
      delete card_path(card)
    end

    assert_not CardPhone.exists?(phone.id)
    assert_not Stat.exists?(stat.id)
  end

  test 'an expiring card triggers a warning email' do
    payments(:one).update!(paid_to: 6.days.from_now + 1.hour)

    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      NotifyCardExpirationJob.perform_now
    end
    assert_equal 'One of your cards expires in a week',
                 ActionMailer::Base.deliveries.last.subject
  end
end
