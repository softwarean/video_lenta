require 'test_helper'

class BroadcastingStatusUpdaterTest < ActionController::TestCase
  setup do
    @broadcasting = create :broadcasting
  end

  test "should update by camera_json" do
    timestamp = Time.now.utc.to_i
    data = {"last" => timestamp}
    stub_request(:any, /.*/).to_return(status: 200, body: data.to_json)

    BroadcastingStatusUpdater.update_by(:camera_json)

    @broadcasting.reload

    assert_equal timestamp, @broadcasting.last_frame_time.utc.to_i
  end
end
