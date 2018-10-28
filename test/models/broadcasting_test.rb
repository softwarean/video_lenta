require 'test_helper'

class BroadcastingTest < ActiveSupport::TestCase
  setup do
    @broadcasting = create :active_broadcasting
  end

  test "gets broadcasting status" do
    assert @broadcasting.status
  end
end
