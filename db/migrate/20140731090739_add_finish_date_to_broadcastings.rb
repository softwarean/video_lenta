class AddFinishDateToBroadcastings < ActiveRecord::Migration
  def change
    add_column :broadcastings, :finish_date, :date
  end
end
