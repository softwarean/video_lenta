class SetCameraTypeForBroadcasting < ActiveRecord::Migration
  def change
    Broadcasting.update_all(camera_type: :http)
  end
end
