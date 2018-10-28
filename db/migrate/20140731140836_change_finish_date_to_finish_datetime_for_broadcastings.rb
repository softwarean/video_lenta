class ChangeFinishDateToFinishDatetimeForBroadcastings < ActiveRecord::Migration
  def change
    remove_column :broadcastings, :finish_date, :date
    add_column :broadcastings, :finish_datetime, :datetime
  end
end
