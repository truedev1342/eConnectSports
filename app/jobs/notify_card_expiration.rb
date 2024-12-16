class NotifyCardExpiration
  @queue = :notify_card

  def self.perform
    payments = Payment.where(paid_to: Time.zone.now+6.day..Time.zone.now+7.days)
    payments.each{ |p| Notifications.card_expires_in_week(p.card).deliver }

    payments = Payment.where(paid_to: Time.zone.now-1.day..Time.zone.now)
    payments.each{ |p| Notifications.card_expired(p.card).deliver }
  end
end