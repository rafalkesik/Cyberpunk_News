class MailerService
  def self.send_email(user, notification, *args)
    # Default behaviour for dev env
    if Rails.env.development?
      Devise::Mailer.send(notification, user, *args).deliver_later
      return
    end

    # Generate the Devise mailer message
    message = Devise.mailer.send(notification, user, *args)
    # Extract email subject and content
    subject = message.subject
    content = message.body.raw_source # Extract raw email content (text/html)
    # Send email using SendGrid API
    ApplicationMailer.new.send_email(user.email, subject, content)
  end
end
