class AddPathToBroadcastings < ActiveRecord::Migration
  def change
    add_column :broadcastings, :path, :string
  end
end
