require 'test_helper'

class NotifyCardExpirationJobTest < ActiveJob::TestCase
  setup do
    Payment.update_all(paid_to: nil)
    ActionMailer::Base.deliveries.clear
  end

  test 'queues on the notify_card queue' do
    assert_equal 'notify_card', NotifyCardExpirationJob.new.queue_name
  end

  test 'warns about a card expiring in a week' do
    payments(:one).update!(paid_to: 6.days.from_now + 1.hour)

    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      NotifyCardExpirationJob.perform_now
    end
    assert_equal 'One of your cards expires in a week',
                 ActionMailer::Base.deliveries.last.subject
  end

  test 'notifies about a card that just expired' do
    payments(:one).update!(paid_to: 2.hours.ago)

    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      NotifyCardExpirationJob.perform_now
    end
    assert_equal 'One of your cards expired', ActionMailer::Base.deliveries.last.subject
  end

  test 'sends nothing when no payment is near its expiry date' do
    payments(:one).update!(paid_to: 3.months.from_now)

    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      NotifyCardExpirationJob.perform_now
    end
  end

  test 'ignores payments that carry no card' do
    Payment.update_all(card_id: nil, paid_to: 2.hours.ago)

    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      NotifyCardExpirationJob.perform_now
    end
  end

  test 'can be enqueued for later' do
    assert_enqueued_with(job: NotifyCardExpirationJob) do
      NotifyCardExpirationJob.perform_later
    end
  end
end
