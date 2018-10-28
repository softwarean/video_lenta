class AddCameraNameToBroadcastings < ActiveRecord::Migration
  def change
    add_column :broadcastings, :camera_name, :string
  end
end
