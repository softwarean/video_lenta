class AddActualReportIndex < ActiveRecord::Migration
  def change
    add_index :reports, :state
  end
end
