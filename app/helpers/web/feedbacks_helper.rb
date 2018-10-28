module Web::FeedbacksHelper
  def referer
    if @user_data
      @user_data["referer"]
    else
      request.referer
    end
  end
end
