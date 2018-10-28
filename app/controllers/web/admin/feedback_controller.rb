class Web::Admin::FeedbackController < Web::Admin::ApplicationController
  def index
    @feedbacks = Feedback.order(id: :desc)
  end

  def show
    @feedback = Feedback.find(params[:id])
  end
end
