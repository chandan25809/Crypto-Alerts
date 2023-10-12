class AlertEmailJob
  include Sidekiq::Worker

  def perform(alert_ids, symbol, price)
    alert_ids.each do |alert_id|
      user_id = Alert.where(id: alert_id).pluck(:user_id).first
      user = User.where(id: user_id).pluck(:email).first

      if user && user.email.present?
        subject = "Price Alert for Coin #{symbol} at Price $#{price}"
        AlertMailer.send_alert_email(user_mail, alert).deliver_now
      end
    end
  end
end
