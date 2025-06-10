class NotifyCardExpirationJob < ApplicationJob
  queue_as :notify_card

  def perform
    expiring_soon.each { |payment| Notifications.card_expires_in_week(payment.card).deliver_now }
    just_expired.each { |payment| Notifications.card_expired(payment.card).deliver_now }
  end

  private

  def expiring_soon
    payments_with_a_card.where(paid_to: 6.days.from_now..7.days.from_now)
  end

  def just_expired
    payments_with_a_card.where(paid_to: 1.day.ago..Time.zone.now)
  end

  # joins(:card) is an inner join, so payments whose card was deleted are left
  # out instead of blowing up on `payment.card.user`.
  def payments_with_a_card
    Payment.joins(:card)
  end
end
