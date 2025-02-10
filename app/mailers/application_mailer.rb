class ApplicationMailer < ActionMailer::Base
  default from: 'rafal.kesik.g@gmail.com'
  layout 'mailer'

  def send_email(to, subject, content)
    require 'sendgrid-ruby'
    include SendGrid

    from = Email.new(email: 'rafal.kesik.g@gmail.com',
                     name: 'Cyberpunk News Team') # Verified "From" email
    to = Email.new(email: to)
    content = Content.new(type: 'text/html', value: content) # Or 'text/plain' for plain text
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    Rails.logger.info "Sending email via SendGrid..."
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    Rails.logger.info "SendGrid Response Status: #{response.status_code}"

    # You can handle the response if needed
    return if response.status_code == '202'

    Rails.logger.error "Error sending email via SendGrid: Status #{response.status_code}"
    Rails.logger.error "Response Body: #{response.body}"
    Rails.logger.error "Response Headers: #{response.headers}"
  end
end
