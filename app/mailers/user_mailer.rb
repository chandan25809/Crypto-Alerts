class UserMailer < ApplicationMailer
  default from: 'chandanmuchukota2001@gmail.com' #replace with you mail id

  def send_alert_email(user_mail, subject)
    mail(to: user_mail.email, subject: subject)
  end
end
