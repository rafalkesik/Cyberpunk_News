class ApplicationMailer < ActionMailer::Base
  require 'sendgrid-ruby'
  include SendGrid

  default from: 'rafal.kesik.g@gmail.com'
  layout 'mailer'

  def send_email(to, subject, content)
    from = Email.new(email: 'no-reply@yourdomain.com') # Verified "From" email
    to = Email.new(email: to)
    content = Content.new(type: 'text/html', value: content) # Or 'text/plain' for plain text
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    # You can handle the response if needed
    puts response.status_code
    puts response.body
    puts response.headers
    Rails.logger.info "SendGrid Response: #{response.status_code}"
    return if response.status_code == '202'

    Rails.logger.error "Error sending email: #{response.body}"
  end
end
