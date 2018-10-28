class AddStateToBroadcastings < ActiveRecord::Migration
  def change
    add_column :broadcastings, :state, :string
  end
end
