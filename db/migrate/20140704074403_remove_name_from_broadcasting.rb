class RemoveNameFromBroadcasting < ActiveRecord::Migration
  def change
    remove_column :broadcastings, :name, :string
  end
end
