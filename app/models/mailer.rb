class Mailer < ActionMailer::Base
  FROM_NAME = "Original Projects"
  FROM_EMAIL = "info@originalprojects.com"
  
  def password_reset(profile)
    setup_mail

    recipients  profile.email
    subject     "Your Original Projects Password"
    body        :password_reset_url => password_url(profile.perishable_token)
  end

  def user_specified_message(message)
    setup_mail

    @from = "#{message.from.display_name} <#{FROM_EMAIL}>"
    reply_to    message.from.email    
    recipients  message.to.email
    subject     message.subject
    body        :sender_name => message.from.display_name, :message => message.body
  end

  def invite(invite)
    setup_mail

    @subject = "You've signed up for Original Projects"
    @body = { :invite => invite, :invite_request => invite.invite_request }
    @recipients = invite.invite_request.email_address
  end

  def feedback(info)
    setup_mail

    reply_to info[:email]
    recipients  "nathan@originalprojects.com,ed@originalprojects.com"
    subject     "[OP] Feedback Received"
    body        :info => info
  end
  
  def setup_mail
    @from = "#{FROM_NAME} <#{FROM_EMAIL}>" 
  end
end
