class AlertEmailJob
  include Sidekiq::Worker

  def perform(alert_ids, symbol, price)
    alert_ids.each do |alert_id|
      alert=Alert.find(alert_id)
      user_id = alert.pluck(:user_id).first
      user =  User.find(user_id)

      if user && user.email.present?
        subject = "Price Alert for Coin #{symbol} at Price $#{price}"
        AlertMailer.send_alert_email(user_mail, alert).deliver_now
        alert.update(state: "triggered")
      end
    end
  end
end
