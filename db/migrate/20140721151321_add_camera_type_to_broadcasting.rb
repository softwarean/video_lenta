class AddCameraTypeToBroadcasting < ActiveRecord::Migration
  def change
    add_column :broadcastings, :camera_type, :string
  end
end
