class AddPollCameraToBroadcastings < ActiveRecord::Migration
  def change
    add_column :broadcastings, :poll_camera, :boolean, default: true
  end
end
