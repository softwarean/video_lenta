class AddStatusAndLastFrameTimestampToBroadcastings < ActiveRecord::Migration
  def change
    add_column :broadcastings, :last_frame_time, :datetime
  end
end
