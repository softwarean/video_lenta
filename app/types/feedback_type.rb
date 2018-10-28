class FeedbackType < Feedback
  include ApplicationType

  validates :email, email: true, allow_blank: true
  validates :email, length: { maximum: 255 }
  validates :author, length: { maximum: 255 }

  permit :reason, :text, :author, :email, user_data: [:referer, :user_agent, :ip]
end
