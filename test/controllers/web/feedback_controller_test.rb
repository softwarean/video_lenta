require 'test_helper'

class Web::FeedbacksControllerTest < ActionController::TestCase
  test "should get index" do
    get :new
    assert_response :success
  end

  test "should create feedback" do
    feedback_attrs = attributes_for :feedback
    post :create, feedback: feedback_attrs
    new_feedback = Feedback.find_by(text: feedback_attrs[:text])

    assert new_feedback, 'no feedback created'
    assert_response :redirect
  end

  test "should get feedback" do
    get :show
    assert_response :success
  end
end
