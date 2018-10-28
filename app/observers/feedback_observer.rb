class FeedbackObserver < ActiveRecord::Observer
  def after_commit(comment)
    FeedbackMailer.notify_email(comment).deliver
  end
end
