require 'test_helper'

class BroadcastingReportBuilder::CameraAvailabilityCalculatorTest < ActionController::TestCase
  setup do
    Calc = BroadcastingReportBuilder::CameraAvailabilityCalculator
  end

  test "should calculate availability" do
    timestamps = [1, 3].map {|el| el * 60}
    first_time = timestamps.first
    last_time = timestamps.last


    result = Calc.calculate(first_time, last_time, timestamps)
    assert_equal "#{(2.0*100/3.0).round}% (2/3)", result
  end
end
