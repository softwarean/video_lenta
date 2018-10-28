class RenameReportState < ActiveRecord::Migration
  def change
    rename_column :reports, :state, :queue_state
  end
end
