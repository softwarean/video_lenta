class RenameReportPresentState < ActiveRecord::Migration
  def change
    rename_column :reports, :present_state, :state
  end
end
