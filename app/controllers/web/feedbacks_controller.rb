class Web::FeedbacksController < Web::ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = FeedbackType.new(feedback_params)

    if @feedback.save
      redirect_to action: :show
    else
      @user_data = feedback_params["user_data"]
      render :new
    end
  end

  def show
  end

  private

  def feedback_params
    params.require(:feedback)
  end
end
