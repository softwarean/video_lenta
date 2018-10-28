class FeedbackMailer < ActionMailer::Base
  default from: configus.feedback.mail.from,
          to: configus.feedback.mail.to

  def notify_email(feedback)
    @feedback = feedback
    mail(subject: "#{feedback.id} — #{feedback.reason.text}")
  end
end
